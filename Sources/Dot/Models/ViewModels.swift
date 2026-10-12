import Foundation
import SwiftUI
import AppKit

// MARK: - Avatar Animation & Gaze View Model
public class AvatarAnimationState: ObservableObject {
    public static let shared = AvatarAnimationState()

    @Published public var isBlinking: Bool = false
    @Published public var pupilOffset: CGSize = .zero

    @Published public var breathingOffset: CGFloat = 0
    @Published public var breathingScale: CGFloat = 1.0
    @Published public var squishScaleX: CGFloat = 1.0
    @Published public var squishScaleY: CGFloat = 1.0
    @Published public var orbitRotation: Double = 0
    @Published public var speakingPulse: CGFloat = 1.0
    @Published public var sleepZOffset: CGFloat = 0

    private var blinkTimer: Timer?

    private init() {}

    public func startBlinkLoop() {
        scheduleNextBlink()
    }

    public func stopBlinkLoop() {
        blinkTimer?.invalidate()
        blinkTimer = nil
    }

    private func scheduleNextBlink() {
        let interval = Double.random(in: 3.0...6.0)
        blinkTimer?.invalidate()
        blinkTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard DotState.shared.mood != .sleeping && DotState.shared.mood != .happy else {
                    self.scheduleNextBlink()
                    return
                }
                self.isBlinking = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    self.isBlinking = false
                    self.scheduleNextBlink()
                }
            }
        }
    }

    public func updatePupil(for mood: DotMood, eyeSize: CGFloat) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            switch mood {
            case .thinking:
                pupilOffset = CGSize(width: -2, height: -eyeSize * 0.22)
            case .puzzled:
                pupilOffset = CGSize(width: eyeSize * 0.15, height: -eyeSize * 0.1)
            case .attentive:
                pupilOffset = CGSize(width: 0, height: eyeSize * 0.1)
            case .speaking:
                pupilOffset = CGSize(width: 0, height: 0)
            default:
                pupilOffset = .zero
            }
        }
    }

    public func poke() {
        withAnimation(.easeOut(duration: 0.08)) {
            squishScaleX = 1.22
            squishScaleY = 0.78
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.45)) {
                self.squishScaleX = 1.0
                self.squishScaleY = 1.0
            }
        }
    }

    public func startAmbientAnimations() {
        withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
            breathingOffset = -3
            breathingScale = 1.03
        }
        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            orbitRotation = 360
        }
        withAnimation(.easeInOut(duration: 0.45).repeatForever(autoreverses: true)) {
            speakingPulse = 1.25
        }
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            sleepZOffset = -8
        }
    }
}

// MARK: - Chat HUD View Model
public class ChatViewModel: ObservableObject {
    public static let shared = ChatViewModel()

    @Published public var inputText: String = ""
    @Published public var isSending: Bool = false
    @Published public var attachedImage: NSImage? = nil

    private init() {}

    @MainActor
    public func sendCurrentMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let capturedImage = attachedImage
        inputText = ""
        attachedImage = nil

        DotState.shared.appendUserMessage(trimmed, image: capturedImage)
        DotState.shared.setMood(.thinking)
        isSending = true

        Task {
            do {
                let (response, action) = try await GeminiService.shared.sendMessage(
                    prompt: trimmed,
                    image: capturedImage,
                    conversationHistory: DotState.shared.messages
                )

                await MainActor.run {
                    DotState.shared.appendModelMessage(response, action: action)
                    DotState.shared.setMood(.happy, duration: 2.0)
                    self.isSending = false
                    SpeechService.shared.speak(response)
                }
            } catch {
                await MainActor.run {
                    DotState.shared.appendModelMessage("⚠️ \(error.localizedDescription)")
                    DotState.shared.setMood(.puzzled, duration: 2.5)
                    self.isSending = false
                }
            }
        }
    }
}

// MARK: - Settings View Model
public class SettingsViewModel: ObservableObject {
    public static let shared = SettingsViewModel()

    @Published public var isShowingApiKey: Bool = false
    @Published public var selectedTab: Int = 0

    private init() {}
}

// MARK: - Goals View Model
public class GoalsViewModel: ObservableObject {
    public static let shared = GoalsViewModel()

    @Published public var selectedTab: Int = 0 // 0: Agents, 1: Activity View, 2: Memory, 3: Autonomy Rules
    @Published public var isAddingNewGoal: Bool = false
    @Published public var newTitle: String = ""
    @Published public var newPrompt: String = ""
    @Published public var newCategory: GoalCategory = .custom
    @Published public var newAutonomyLevel: AutonomyLevel = .full
    @Published public var newIntervalMinutes: Double = 15

    // Memory tab state
    @Published public var isAddingMemory: Bool = false
    @Published public var newMemoryFact: String = ""
    @Published public var newMemoryCategory: String = "preferences"

    private init() {}

    public func saveNewGoal() {
        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let prompt = newPrompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty && !prompt.isEmpty else { return }

        let goal = TaskGoal(
            title: title,
            prompt: prompt,
            intervalSeconds: newIntervalMinutes * 60,
            isEnabled: true,
            autonomyLevel: newAutonomyLevel,
            category: newCategory
        )
        Task { @MainActor in
            DotState.shared.goals.append(goal)
            self.newTitle = ""
            self.newPrompt = ""
            self.isAddingNewGoal = false
        }
    }
}
