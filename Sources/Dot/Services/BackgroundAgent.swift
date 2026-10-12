import Foundation

public class BackgroundAgent {
    public static let shared = BackgroundAgent()

    private var timer: Timer?
    private var isProcessingGoal: Bool = false

    private init() {}

    public func start() {
        stop()
        // Check goals every 15 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: true) { [weak self] _ in
            self?.checkGoals()
        }
    }

    public func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func checkGoals() {
        guard !isProcessingGoal else { return }

        Task { @MainActor in
            let now = Date()
            guard let dueIndex = DotState.shared.goals.firstIndex(where: { goal in
                guard goal.isEnabled && goal.autonomyLevel != .disabled && goal.autonomyLevel != .onDemand else {
                    return false
                }
                guard let last = goal.lastRun else { return true }
                return now.timeIntervalSince(last) >= goal.intervalSeconds
            }) else {
                return
            }

            let goal = DotState.shared.goals[dueIndex]
            isProcessingGoal = true

            // Update goal run time
            DotState.shared.goals[dueIndex].lastRun = now
            DotState.shared.goals[dueIndex].runCount += 1

            await executeGoal(goal: goal, index: dueIndex)

            isProcessingGoal = false
        }
    }

    @MainActor
    public func executeGoal(goal: TaskGoal, index: Int) async {
        let lang = DotConfig.shared.language

        // Handle based on category for maximum efficiency & accuracy
        switch goal.category {
        case .hardware:
            let battery = SystemService.shared.getBatteryStatus()
            let isLowBattery = battery.contains(";") && (
                battery.contains("10%") || battery.contains("11%") || battery.contains("12%") ||
                battery.contains("13%") || battery.contains("14%") || battery.contains("15%") ||
                battery.contains("16%") || battery.contains("17%") || battery.contains("18%") ||
                battery.contains("19%")
            ) && !battery.lowercased().contains("charging")

            let summaryText: String
            if isLowBattery {
                summaryText = lang == .russian ? "⚠️ Низкий заряд батареи! Подключи Mac к питанию." : "⚠️ Low battery warning! Please plug in your Mac."
                DotState.shared.showSpeechBubble(summaryText, duration: 4.0)
                SystemService.shared.postNotification(title: "Dot Battery Sentinel", message: summaryText)
                SpeechService.shared.playWakeupSound()
            } else {
                summaryText = lang == .russian ? "Состояние батареи в норме (\(battery))" : "Battery status nominal (\(battery))"
            }

            DotState.shared.goals[index].lastResult = summaryText
            ActivityLogService.shared.log(
                goalTitle: goal.title,
                summary: summaryText,
                fullDetails: battery,
                type: .hardware,
                notificationSent: isLowBattery
            )

        case .wellness:
            let wellnessText: String
            switch lang {
            case .russian:
                wellnessText = "🧘 Время размяться! Отведи взгляд от экрана, сделай глубокий вдох и выпей воды."
            case .chinese:
                wellnessText = "🧘 休息时间到！请让眼睛离开屏幕片刻，深呼吸并喝一口水。"
            case .japanese:
                wellnessText = "🧘 リフレッシュの時間です！画面から目を離して水分補給をしましょう。"
            default:
                wellnessText = "🧘 Time for a quick break! Stretch your neck, rest your eyes, and take a sip of water."
            }

            DotState.shared.showSpeechBubble(wellnessText, duration: 4.5)
            DotState.shared.goals[index].lastResult = wellnessText
            SpeechService.shared.playPopSound()

            ActivityLogService.shared.log(
                goalTitle: goal.title,
                summary: wellnessText,
                type: .wellness,
                notificationSent: true
            )

        case .research:
            // Proactive research agent: performs live search and generates briefing
            let query = goal.prompt.contains("Search:") ? goal.prompt.replacingOccurrences(of: "Search:", with: "").trimmingCharacters(in: .whitespacesAndNewlines) : goal.title
            let searchResults = await WebResearchService.shared.search(query: query)

            var searchContext = ""
            if !searchResults.isEmpty {
                searchContext = searchResults.prefix(3).map { "• \($0.title): \($0.snippet)" }.joined(separator: "\n")
            }

            let prompt = """
[PROACTIVE RESEARCH AGENT GOAL]
Task: \(goal.title)
Query Context: \(searchContext)
Language: \(lang.displayName)

Summarize the most interesting or recent update concisely in 1-2 thoughtful sentences.
"""

            do {
                let (response, _) = try await GeminiService.shared.sendMessage(prompt: prompt)
                DotState.shared.goals[index].lastResult = response

                let notifyUser = goal.autonomyLevel == .full
                if notifyUser {
                    DotState.shared.showSpeechBubble("📰 Дайджест: \(response.prefix(75))...", duration: 4.0)
                    SpeechService.shared.playSuccessSound()
                }

                ActivityLogService.shared.log(
                    goalTitle: goal.title,
                    summary: response,
                    fullDetails: searchContext,
                    type: .research,
                    notificationSent: notifyUser
                )
            } catch {
                let errText = "Error: \(error.localizedDescription)"
                DotState.shared.goals[index].lastResult = errText
                ActivityLogService.shared.log(goalTitle: goal.title, summary: errText, type: .research)
            }

        case .memory, .custom:
            let backgroundPrompt = """
[AUTONOMOUS MICRO-AGENT EXECUTION]
Agent Title: \(goal.title)
Instruction: \(goal.prompt)
Current Date & Time: \(Date())
Mac Status: \(SystemService.shared.getBatteryStatus())

Execute the requested task. If something warrants user notification, output <<<NOTIFY: Title | Message>>>. Otherwise provide a clear, concise result.
"""
            do {
                let (response, action) = try await GeminiService.shared.sendMessage(prompt: backgroundPrompt)
                DotState.shared.goals[index].lastResult = response

                let hadNotification = response.contains("<<<NOTIFY:") || action != nil
                if hadNotification {
                    DotState.shared.showSpeechBubble("⚡ Агент выполнил задачу: \(goal.title)", duration: 3.5)
                    SpeechService.shared.playSuccessSound()
                }

                ActivityLogService.shared.log(
                    goalTitle: goal.title,
                    summary: response.prefix(120).description,
                    fullDetails: response,
                    type: goal.category == .memory ? .memory : .action,
                    notificationSent: hadNotification
                )
            } catch {
                let errText = "Error: \(error.localizedDescription)"
                DotState.shared.goals[index].lastResult = errText
                ActivityLogService.shared.log(goalTitle: goal.title, summary: errText, type: .system)
            }
        }
    }
}
