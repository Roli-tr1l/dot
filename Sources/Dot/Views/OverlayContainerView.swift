import Foundation
import SwiftUI
import AppKit

public struct OverlayContainerView: View {
    @ObservedObject var state: DotState = DotState.shared
    @ObservedObject var config: DotConfig = DotConfig.shared

    public var body: some View {
        VStack(spacing: 8) {
            // Speech Bubble Popup above Dot (if active)
            if let speech = state.speechBubbleText {
                SpeechBubblePopup(text: speech)
                    .transition(.scale.combined(with: .opacity))
            }

            // Main Row: Avatar + Panels
            HStack(alignment: .top, spacing: 14) {
                // Living Avatar with Native Smooth Drag
                DotAvatarView()

                // Expanded Side Panel (Chat, Settings, or Goals)
                if state.isChatOpen || state.isSettingsOpen || state.isGoalsOpen {
                    ZStack {
                        if state.isSettingsOpen {
                            SettingsView()
                                .transition(.asymmetric(insertion: .scale(scale: 0.95).combined(with: .opacity), removal: .opacity))
                        } else if state.isGoalsOpen {
                            GoalsView()
                                .transition(.asymmetric(insertion: .scale(scale: 0.95).combined(with: .opacity), removal: .opacity))
                        } else {
                            ChatBubbleView()
                                .transition(.asymmetric(insertion: .scale(scale: 0.95).combined(with: .opacity), removal: .opacity))
                        }
                    }
                }
            }
        }
        .padding(20)
    }
}

// MARK: - Speech Bubble Popup
struct SpeechBubblePopup: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color(red: 0.15, green: 0.16, blue: 0.22).opacity(0.95))
                    .overlay(
                        Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
            )
    }
}
