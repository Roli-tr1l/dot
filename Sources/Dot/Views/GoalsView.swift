import Foundation
import SwiftUI

public struct GoalsView: View {
    @ObservedObject var state: DotState = DotState.shared
    @ObservedObject var config: DotConfig = DotConfig.shared
    @ObservedObject var vm: GoalsViewModel = GoalsViewModel.shared
    @ObservedObject var memoryService: DotMemoryService = DotMemoryService.shared
    @ObservedObject var activityService: ActivityLogService = ActivityLogService.shared

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            headerBar()

            // Navigation Tabs
            tabsBar()

            Divider()
                .background(Color.white.opacity(0.12))

            // Tab Content
            ScrollView {
                VStack(spacing: 12) {
                    if vm.selectedTab == 0 {
                        agentsTab()
                    } else if vm.selectedTab == 1 {
                        activityViewTab()
                    } else if vm.selectedTab == 2 {
                        memoryTab()
                    } else {
                        customRulesTab()
                    }
                }
                .padding(14)
            }
        }
        .frame(width: 440, height: 540)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 0.11, green: 0.12, blue: 0.17).opacity(0.96))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.5), radius: 26, x: 0, y: 12)
        )
    }

    // MARK: - Header
    private func headerBar() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(config.language == .russian ? "Автономные микро-агенты Dots" : "Autonomous Dots Agents")
                        .font(.system(size: 14.5, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("24/7 • Gemini 3.8")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.purple.opacity(0.35)))
                        .foregroundColor(.purple.opacity(0.9))
                }

                Text(config.language == .russian ? "Фоновые микро-агенты, память и Activity View" : "Always-on micro-agents, memory & live activity view")
                    .font(.system(size: 10.5))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            Button {
                withAnimation(.spring(response: 0.3)) {
                    state.isGoalsOpen = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Navigation Tabs Bar
    private func tabsBar() -> some View {
        HStack(spacing: 6) {
            tabButton(title: config.language == .russian ? "🤖 Агенты" : "🤖 Agents", index: 0)
            tabButton(title: config.language == .russian ? "📊 Activity" : "📊 Activity", index: 1)
            tabButton(title: config.language == .russian ? "🧠 Память" : "🧠 Memory", index: 2)
            tabButton(title: config.language == .russian ? "🛡️ Правила" : "🛡️ Rules", index: 3)
        }
        .padding(.horizontal, 14)
        .padding(.bottom, 8)
    }

    private func tabButton(title: String, index: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.25)) {
                vm.selectedTab = index
            }
        } label: {
            Text(title)
                .font(.system(size: 11, weight: vm.selectedTab == index ? .bold : .medium))
                .foregroundColor(vm.selectedTab == index ? .white : .white.opacity(0.65))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(vm.selectedTab == index ? config.colorTheme.primaryColor.opacity(0.35) : Color.white.opacity(0.06))
                )
                .overlay(
                    Capsule()
                        .stroke(vm.selectedTab == index ? config.colorTheme.primaryColor : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tab 0: Agents List
    private func agentsTab() -> some View {
        VStack(spacing: 12) {
            ForEach($state.goals) { $goal in
                goalCard(goal: $goal)
            }

            if vm.isAddingNewGoal {
                newGoalCard()
            } else {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        vm.isAddingNewGoal = true
                    }
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text(config.language.localized(.addGoalButton))
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(config.colorTheme.primaryColor)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(config.colorTheme.primaryColor.opacity(0.5), style: StrokeStyle(lineWidth: 1, dash: [4]))
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
        }
    }

    private func goalCard(goal: Binding<TaskGoal>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: goal.wrappedValue.category.icon)
                    .font(.system(size: 13))
                    .foregroundColor(config.colorTheme.primaryColor)

                Text(goal.wrappedValue.title)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Toggle("", isOn: goal.isEnabled)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            Text(goal.wrappedValue.prompt)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.75))

            // Autonomy Level Selector
            HStack(spacing: 6) {
                Text(config.language == .russian ? "Режим:" : "Mode:")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))

                Picker("", selection: goal.autonomyLevel) {
                    ForEach(AutonomyLevel.allCases) { lvl in
                        Text(lvl.localized(in: config.language)).tag(lvl)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()

                Spacer()

                // Run Now Button for testing
                Button {
                    Task { @MainActor in
                        if let idx = state.goals.firstIndex(where: { $0.id == goal.wrappedValue.id }) {
                            await BackgroundAgent.shared.executeGoal(goal: goal.wrappedValue, index: idx)
                        }
                    }
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "play.fill")
                        Text(config.language == .russian ? "Пуск" : "Run")
                    }
                    .font(.system(size: 10, weight: .semibold))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color.white.opacity(0.12)))
                    .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }

            HStack {
                Text(config.language.everyMinutes(Int(goal.wrappedValue.intervalSeconds / 60)))
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(config.colorTheme.primaryColor)

                Spacer()

                if let last = goal.wrappedValue.lastRun {
                    Text(config.language.lastChecked(last.formatted(date: .omitted, time: .shortened)))
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            if let result = goal.wrappedValue.lastResult {
                Text("\(config.language.localized(.resultLabel)) \(result)")
                    .font(.system(size: 10.5, design: .monospaced))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(6)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.black.opacity(0.3)))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.07))
        )
    }

    private func newGoalCard() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(config.language.localized(.newGoalTitle))
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)

            TextField(config.language.localized(.goalTitlePlaceholder), text: $vm.newTitle)
                .textFieldStyle(.plain)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.1)))
                .foregroundColor(.white)

            TextField(config.language.localized(.goalPromptPlaceholder), text: $vm.newPrompt)
                .textFieldStyle(.plain)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.1)))
                .foregroundColor(.white)

            HStack {
                Text(config.language == .russian ? "Категория:" : "Category:")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))

                Picker("", selection: $vm.newCategory) {
                    ForEach(GoalCategory.allCases) { cat in
                        Text(cat.title(in: config.language)).tag(cat)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()

                Spacer()

                Text(config.language.localized(.intervalLabel))
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))

                Picker("", selection: $vm.newIntervalMinutes) {
                    Text(config.language.everyMinutes(5)).tag(5.0)
                    Text(config.language.everyMinutes(15)).tag(15.0)
                    Text(config.language.everyMinutes(30)).tag(30.0)
                    Text(config.language == .russian ? "1 час" : "1 hour").tag(60.0)
                    Text(config.language == .russian ? "2 часа" : "2 hours").tag(120.0)
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }

            HStack {
                Text(config.language == .russian ? "Автономия:" : "Autonomy:")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))

                Picker("", selection: $vm.newAutonomyLevel) {
                    ForEach(AutonomyLevel.allCases) { lvl in
                        Text(lvl.localized(in: config.language)).tag(lvl)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()

                Spacer()

                Button(config.language.localized(.cancelButton)) {
                    vm.isAddingNewGoal = false
                }
                .buttonStyle(.plain)
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 11))

                Button(config.language.localized(.saveButton)) {
                    vm.saveNewGoal()
                }
                .buttonStyle(.plain)
                .foregroundColor(config.colorTheme.primaryColor)
                .font(.system(size: 12, weight: .bold))
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.12)))
    }

    // MARK: - Tab 1: Activity View Tab (Live Agent Log)
    private func activityViewTab() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(config.language == .russian ? "Хроника действий в реальном времени" : "Real-time Agent Activity Feed")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button(config.language == .russian ? "Очистить" : "Clear") {
                    activityService.clear()
                }
                .buttonStyle(.plain)
                .font(.system(size: 10.5))
                .foregroundColor(.white.opacity(0.5))
            }

            if activityService.records.isEmpty {
                VStack(spacing: 6) {
                    Text("💤")
                        .font(.system(size: 24))
                    Text(config.language == .russian ? "Журнал чист. Агенты выполнят задачи по расписанию." : "Activity feed is clear. Agents will execute per schedule.")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                ForEach(activityService.records) { rec in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Image(systemName: rec.type.icon)
                                .font(.system(size: 11))
                                .foregroundColor(config.colorTheme.primaryColor)

                            Text(rec.goalTitle)
                                .font(.system(size: 11.5, weight: .bold))
                                .foregroundColor(.white)

                            Spacer()

                            if rec.notificationSent {
                                Text("🔔 " + (config.language == .russian ? "Уведомление" : "Alert"))
                                    .font(.system(size: 9))
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 1)
                                    .background(Capsule().fill(Color.orange.opacity(0.2)))
                            }

                            Text(rec.timestamp.formatted(date: .omitted, time: .standard))
                                .font(.system(size: 9.5, design: .monospaced))
                                .foregroundColor(.white.opacity(0.45))
                        }

                        Text(rec.summary)
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.85))

                        if !rec.fullDetails.isEmpty && rec.fullDetails != rec.summary {
                            Text(rec.fullDetails)
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(.white.opacity(0.6))
                                .padding(4)
                                .background(RoundedRectangle(cornerRadius: 4).fill(Color.black.opacity(0.25)))
                        }
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06)))
                }
            }
        }
    }

    // MARK: - Tab 2: Long-term Memory Tab
    private func memoryTab() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(config.language == .russian ? "Долговременная память Dot" : "Dot Long-term Memory")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)

                Text(config.language == .russian ? "Dot помнит эти факты и персонализирует ответы под тебя:" : "Dot remembers these facts and personalizes responses accordingly:")
                    .font(.system(size: 10.5))
                    .foregroundColor(.white.opacity(0.6))
            }

            // Quick Add Fact
            HStack(spacing: 6) {
                TextField(config.language == .russian ? "Запомнить факт (напр. 'Работаю программистом на Mac')..." : "Remember fact...", text: $vm.newMemoryFact)
                    .textFieldStyle(.plain)
                    .padding(7)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.09)))
                    .foregroundColor(.white)
                    .font(.system(size: 11))

                Button {
                    let fact = vm.newMemoryFact.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !fact.isEmpty {
                        memoryService.addMemory(fact: fact, category: "user")
                        vm.newMemoryFact = ""
                    }
                } label: {
                    Text(config.language == .russian ? "Запомнить 💡" : "Add 💡")
                        .font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(config.colorTheme.primaryColor))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }

            if memoryService.memories.isEmpty {
                Text(config.language == .russian ? "Память пока пуста. Добавь факт выше или Dot запомнит его сам в беседе!" : "No memories yet. Add facts above or Dot will learn them during chat.")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.vertical, 20)
            } else {
                ForEach(memoryService.memories) { mem in
                    HStack(spacing: 8) {
                        Image(systemName: "sparkle")
                            .font(.system(size: 11))
                            .foregroundColor(.yellow)

                        VStack(alignment: .leading, spacing: 1) {
                            Text(mem.fact)
                                .font(.system(size: 11.5))
                                .foregroundColor(.white)
                            Text(mem.category.uppercased())
                                .font(.system(size: 8.5, weight: .bold, design: .monospaced))
                                .foregroundColor(.white.opacity(0.4))
                        }

                        Spacer()

                        Button {
                            memoryService.removeMemory(id: mem.id)
                        } label: {
                            Image(systemName: "trash")
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.06)))
                }
            }
        }
    }

    // MARK: - Tab 3: Custom Rules & Autonomy Guardrails
    private func customRulesTab() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(config.language == .russian ? "Уровни автономии и правила безопасности" : "Autonomy Levels & Custom Rules")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)

            Text(config.language == .russian ? "Как и в официальных Dots от OpenAI, ты определяешь границы дозволенного для каждого навыка:" : "As in official OpenAI Dots, you control permission boundaries for every skill:")
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.7))

            ruleCard(
                icon: "🟢",
                title: config.language == .russian ? "1. Полная автономия (Always Allow)" : "1. Full Autonomy",
                desc: config.language == .russian ? "Агент работает 24/7 в фоне, самостоятельно исследует веб, проверяет систему и присылает готовые дайджесты." : "The agent runs 24/7 in the background, researches, and notifies with summaries."
            )

            ruleCard(
                icon: "🟡",
                title: config.language == .russian ? "2. Спрашивать разрешение (Ask First)" : "2. Ask Permission",
                desc: config.language == .russian ? "Перед запуском чувствительных действий Dot запрашивает физическое одобрение пользователя." : "Dot requests physical approval from the user before executing sensitive actions."
            )

            ruleCard(
                icon: "🔵",
                title: config.language == .russian ? "3. Только по запросу (On Demand)" : "3. On Demand",
                desc: config.language == .russian ? "Агент не действует самостоятельно в фоне, а активируется только при явной команде в чате." : "Agent will never run automatically, only upon direct explicit instruction."
            )

            ruleCard(
                icon: "⛔",
                title: config.language == .russian ? "4. Полный запрет (Disabled)" : "4. Complete Denial",
                desc: config.language == .russian ? "Навык полностью отключен и не может быть вызван ИИ." : "Skill is completely disabled."
            )
        }
    }

    private func ruleCard(icon: String, title: String, desc: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(icon)
                .font(.system(size: 16))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 11.5, weight: .bold))
                    .foregroundColor(.white)
                Text(desc)
                    .font(.system(size: 10.5))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06)))
    }
}
