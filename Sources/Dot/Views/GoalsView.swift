import Foundation
import SwiftUI

public struct GoalsView: View {
    @ObservedObject var state: DotState = DotState.shared
    @ObservedObject var config: DotConfig = DotConfig.shared
    @ObservedObject var vm: GoalsViewModel = GoalsViewModel.shared

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Autonomous Goals")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text("Standing background micro-agents")
                        .font(.system(size: 11))
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

            Divider()
                .background(Color.white.opacity(0.12))

            ScrollView {
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
                                Text("Add Standing Goal")
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
                .padding(14)
            }
        }
        .frame(width: 380, height: 460)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 0.12, green: 0.13, blue: 0.18).opacity(0.95))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.5), radius: 24, x: 0, y: 12)
        )
    }

    private func goalCard(goal: Binding<TaskGoal>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
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

            HStack {
                Text("Every \(Int(goal.wrappedValue.intervalSeconds / 60)) min")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(config.colorTheme.primaryColor)

                Spacer()

                if let last = goal.wrappedValue.lastRun {
                    Text("Last checked: \(last.formatted(date: .omitted, time: .shortened))")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            if let result = goal.wrappedValue.lastResult {
                Text("Result: \(result)")
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
            Text("New Goal")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)

            TextField("Goal Title (e.g. Battery Sentinel)", text: $vm.newTitle)
                .textFieldStyle(.plain)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.1)))
                .foregroundColor(.white)

            TextField("Prompt instruction for Gemini...", text: $vm.newPrompt)
                .textFieldStyle(.plain)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.1)))
                .foregroundColor(.white)

            HStack {
                Text("Interval:")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.8))

                Picker("", selection: $vm.newIntervalMinutes) {
                    Text("5 min").tag(5.0)
                    Text("15 min").tag(15.0)
                    Text("30 min").tag(30.0)
                    Text("1 hour").tag(60.0)
                }
                .pickerStyle(.menu)
                .labelsHidden()

                Spacer()

                Button("Cancel") {
                    vm.isAddingNewGoal = false
                }
                .buttonStyle(.plain)
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 11))

                Button("Save") {
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
}
