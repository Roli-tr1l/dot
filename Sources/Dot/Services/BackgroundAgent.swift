import Foundation

public class BackgroundAgent {
    public static let shared = BackgroundAgent()

    private var timer: Timer?
    private var isProcessingGoal: Bool = false

    private init() {}

    public func start() {
        stop()
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
                guard goal.isEnabled else { return false }
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

            let backgroundPrompt = """
[AUTONOMOUS BACKGROUND GOAL EXECUTION]
Goal Title: \(goal.title)
Goal Prompt: \(goal.prompt)
Current local time: \(Date())
Mac Battery: \(SystemService.shared.getBatteryStatus())

Please inspect the system or perform whatever check is requested. If anything important requires user attention, use <<<NOTIFY: Title | Message>>> or provide a concise update. If all is nominal, keep it to one short sentence.
"""

            do {
                let (response, action) = try await GeminiService.shared.sendMessage(prompt: backgroundPrompt)
                DotState.shared.goals[dueIndex].lastResult = response

                if response.contains("<<<NOTIFY:") || action != nil {
                    DotState.shared.showSpeechBubble("Task update: \(goal.title)", duration: 3.0)
                    SpeechService.shared.playSuccessSound()
                }
            } catch {
                DotState.shared.goals[dueIndex].lastResult = "Error: \(error.localizedDescription)"
            }

            isProcessingGoal = false
        }
    }
}
