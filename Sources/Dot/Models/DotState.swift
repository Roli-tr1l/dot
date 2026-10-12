import Foundation
import SwiftUI
import AppKit

public enum DotMood: String, CaseIterable, Codable {
    case idle = "Idle"
    case attentive = "Attentive"
    case thinking = "Thinking"
    case speaking = "Speaking"
    case happy = "Happy"
    case puzzled = "Puzzled"
    case sleeping = "Sleeping"

    public var statusDescription: String {
        switch self {
        case .idle: return "Chilling"
        case .attentive: return "Listening..."
        case .thinking: return "Thinking with Gemini..."
        case .speaking: return "Speaking..."
        case .happy: return "Super happy!"
        case .puzzled: return "Hmm..."
        case .sleeping: return "Zzz..."
        }
    }
}

@MainActor
public class DotState: ObservableObject {
    public static let shared = DotState()

    @Published public var mood: DotMood = .idle
    @Published public var isChatOpen: Bool = false
    @Published public var isSettingsOpen: Bool = false
    @Published public var isGoalsOpen: Bool = false
    @Published public var isHovered: Bool = false
    @Published public var isDragging: Bool = false
    @Published public var cursorPosition: CGPoint = .zero
    @Published public var avatarPosition: CGPoint = CGPoint(x: 200, y: 200)

    @Published public var messages: [ChatMessage] = []
    @Published public var goals: [TaskGoal] = []
    @Published public var currentActionStatus: String? = nil
    @Published public var speechBubbleText: String? = nil

    private var lastActivityTime: Date = Date()
    private var sleepCheckTimer: Timer?
    private var speechBubbleDismissTask: Task<Void, Never>?

    private init() {
        loadDefaultGoals()
        startSleepTimer()
    }

    public func wakeUp() {
        lastActivityTime = Date()
        if mood == .sleeping {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                mood = .idle
            }
            showSpeechBubble("Hey! I'm awake! 👋", duration: 2.0)
        }
    }

    public func setMood(_ newMood: DotMood, duration: Double? = nil) {
        lastActivityTime = Date()
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            self.mood = newMood
        }
        if let duration = duration {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                if self.mood == newMood {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        self.mood = .idle
                    }
                }
            }
        }
    }

    public func showSpeechBubble(_ text: String, duration: Double = 3.5) {
        speechBubbleDismissTask?.cancel()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
            self.speechBubbleText = text
        }
        speechBubbleDismissTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            if !Task.isCancelled {
                withAnimation(.easeOut(duration: 0.25)) {
                    self.speechBubbleText = nil
                }
            }
        }
    }

    public func appendUserMessage(_ text: String, image: NSImage? = nil) {
        let msg = ChatMessage(role: .user, text: text, image: image)
        messages.append(msg)
        wakeUp()
    }

    public func appendModelMessage(_ text: String, action: ActionRecord? = nil) {
        let msg = ChatMessage(role: .model, text: text, action: action)
        messages.append(msg)
        wakeUp()
    }

    private func startSleepTimer() {
        sleepCheckTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                guard DotConfig.shared.autoSleep else { return }
                let idleTime = Date().timeIntervalSince(self.lastActivityTime)
                if idleTime > DotConfig.shared.sleepTimeoutSeconds && self.mood != .sleeping && self.mood != .thinking && self.mood != .speaking && !self.isChatOpen {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        self.mood = .sleeping
                    }
                }
            }
        }
    }

    private func loadDefaultGoals() {
        self.goals = [
            TaskGoal(
                title: "Mac Battery Sentinel",
                prompt: "Check battery percentage. If below 20% and not charging, warn the user.",
                intervalSeconds: 600,
                isEnabled: false
            ),
            TaskGoal(
                title: "Desk Break & Posture Check",
                prompt: "Remind the user to stretch, blink, and take a sip of water.",
                intervalSeconds: 3600,
                isEnabled: false
            )
        ]
    }
}
