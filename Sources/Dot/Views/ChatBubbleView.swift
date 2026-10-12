import Foundation
import SwiftUI
import AppKit

public struct ChatBubbleView: View {
    @ObservedObject var state: DotState = DotState.shared
    @ObservedObject var config: DotConfig = DotConfig.shared
    @ObservedObject var vm: ChatViewModel = ChatViewModel.shared

    public var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            headerBar()

            // ChatGPT Mascot Lineup Switcher
            mascotPresetsSwitcher()

            Divider()
                .background(Color.white.opacity(0.12))

            // Quick Mac Superpowers Toolbar
            quickActionsToolbar()

            Divider()
                .background(Color.white.opacity(0.12))

            // Messages Scroll View
            messagesScrollView()

            Divider()
                .background(Color.white.opacity(0.12))

            // Attached image preview
            if let image = vm.attachedImage {
                imageAttachmentBar(image)
            }

            // Input Bar
            inputBar()
        }
        .frame(width: 390, height: 500)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 0.11, green: 0.12, blue: 0.16).opacity(0.92))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.16), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.45), radius: 26, x: 0, y: 12)
        )
    }

    // MARK: - Header
    private func headerBar() -> some View {
        HStack(spacing: 10) {
            Circle()
                .fill(config.colorTheme.primaryColor)
                .frame(width: 10, height: 10)
                .shadow(color: config.colorTheme.primaryColor, radius: 4)

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(config.preset.rawValue)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Antigravity • \(config.model)")
                        .font(.system(size: 9, weight: .medium, design: .monospaced))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.white.opacity(0.12)))
                        .foregroundColor(.white.opacity(0.8))
                }

                Text(state.mood.statusDescription)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            Button {
                withAnimation(.spring(response: 0.3)) {
                    state.isGoalsOpen.toggle()
                }
            } label: {
                Image(systemName: "checklist")
                    .font(.system(size: 13))
                    .foregroundColor(state.isGoalsOpen ? config.colorTheme.primaryColor : .white.opacity(0.75))
            }
            .buttonStyle(.plain)
            .help("Autonomous Goals")

            Button {
                withAnimation(.spring(response: 0.3)) {
                    state.isSettingsOpen.toggle()
                }
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 13))
                    .foregroundColor(state.isSettingsOpen ? config.colorTheme.primaryColor : .white.opacity(0.75))
            }
            .buttonStyle(.plain)
            .help("Preferences & API")

            Button {
                withAnimation(.spring(response: 0.3)) {
                    state.isChatOpen = false
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }

    // MARK: - Mascot Lineup Switcher (ChatGPT Dots)
    private func mascotPresetsSwitcher() -> some View {
        HStack(spacing: 6) {
            ForEach(DotPreset.allCases) { p in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                        config.applyPreset(p)
                    }
                    SpeechService.shared.playPopSound()
                    state.showSpeechBubble("Switched to \(p.rawValue)! ✨", duration: 1.8)
                } label: {
                    HStack(spacing: 4) {
                        Text(p.emoji)
                            .font(.system(size: 12))
                        Text(p.rawValue)
                            .font(.system(size: 10, weight: config.preset == p ? .bold : .medium))
                    }
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(config.preset == p ? config.colorTheme.primaryColor.opacity(0.35) : Color.white.opacity(0.06))
                    )
                    .overlay(
                        Capsule()
                            .stroke(config.preset == p ? config.colorTheme.primaryColor : Color.clear, lineWidth: 1.2)
                    )
                    .foregroundColor(config.preset == p ? .white : .white.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.2))
    }

    // MARK: - Quick Mac Superpowers Toolbar
    private func quickActionsToolbar() -> some View {
        HStack(spacing: 8) {
            quickButton(icon: "doc.on.clipboard", title: "Clipboard") {
                if let clip = SystemService.shared.getClipboardText(), !clip.isEmpty {
                    vm.inputText = "Here is what's in my clipboard:\n\"\"\"\n\(clip.prefix(500))\n\"\"\"\nCan you explain or help with this?"
                } else {
                    state.showSpeechBubble("Clipboard is empty! 📋", duration: 2.0)
                }
            }

            quickButton(icon: "camera.viewfinder", title: "Look Screen") {
                if let screen = SystemService.shared.captureActiveScreen() {
                    vm.attachedImage = screen
                    if vm.inputText.isEmpty {
                        vm.inputText = "Take a look at my screen and tell me what you see!"
                    }
                    SpeechService.shared.playPopSound()
                }
            }

            quickButton(icon: "bolt.badge.automatic", title: "Mac Health") {
                let battery = SystemService.shared.getBatteryStatus()
                vm.inputText = "Give me a quick Mac status report: \(battery)"
            }

            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.04))
    }

    private func quickButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10))
                Text(title)
                    .font(.system(size: 10, weight: .medium))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Capsule().fill(Color.white.opacity(0.1)))
            .foregroundColor(.white.opacity(0.85))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Messages Scroll View
    private func messagesScrollView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    if state.messages.isEmpty {
                        emptyStateView()
                    } else {
                        ForEach(state.messages) { msg in
                            messageBubbleView(msg)
                                .id(msg.id)
                        }
                    }
                }
                .padding(14)
            }
            .onChange(of: state.messages.count) { _ in
                if let last = state.messages.last {
                    withAnimation {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    private func emptyStateView() -> some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 18)
            Circle()
                .fill(config.colorTheme.primaryColor.opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(config.preset.emoji)
                        .font(.system(size: 24))
                )

            Text("Hey! I'm \(config.preset.rawValue).")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text(config.preset.subtitle)
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.65))
                .padding(.horizontal, 24)

            // Prompt suggestions
            VStack(spacing: 6) {
                promptSuggestionButton("📸 Look at my screen and help me") {
                    if let screen = SystemService.shared.captureActiveScreen() {
                        vm.attachedImage = screen
                        vm.inputText = "Explain what is on my screen and what I should do next."
                    }
                }
                promptSuggestionButton("📋 Explain code from my clipboard") {
                    if let clip = SystemService.shared.getClipboardText(), !clip.isEmpty {
                        vm.inputText = "Here is code from my clipboard:\n```\n\(clip.prefix(500))\n```\nReview it and point out issues."
                    }
                }
                promptSuggestionButton("⚡ Check MacBook battery & system health") {
                    vm.inputText = "Check my Mac battery and tell me how my system is doing."
                }
            }
            .padding(.top, 6)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func promptSuggestionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.08))
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Message Bubble
    private func messageBubbleView(_ msg: ChatMessage) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if msg.role == .model {
                Circle()
                    .fill(config.colorTheme.primaryColor)
                    .frame(width: 22, height: 22)
                    .overlay(
                        Text("•")
                            .font(.system(size: 14, weight: .heavy))
                            .foregroundColor(.white)
                    )
            } else {
                Spacer(minLength: 40)
            }

            VStack(alignment: msg.role == .user ? .trailing : .leading, spacing: 6) {
                if let img = msg.image {
                    Image(nsImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 120)
                        .cornerRadius(8)
                }

                Text(msg.text)
                    .font(.system(size: 12.5))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                msg.role == .user
                                    ? config.colorTheme.primaryColor.opacity(0.85)
                                    : Color.white.opacity(0.12)
                            )
                    )
                    .textSelection(.enabled)

                if let action = msg.action {
                    HStack(spacing: 6) {
                        Image(systemName: action.isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(action.isSuccess ? .green : .orange)
                        Text("Mac Shell: \(action.command)")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.black.opacity(0.35)))
                }
            }

            if msg.role == .user {
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 22, height: 22)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                    )
            } else {
                Spacer(minLength: 40)
            }
        }
    }

    // MARK: - Attached Image Bar
    private func imageAttachmentBar(_ image: NSImage) -> some View {
        HStack {
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 44, height: 32)
                .cornerRadius(4)

            Text("Screen capture attached")
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.8))

            Spacer()

            Button {
                vm.attachedImage = nil
            } label: {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.white.opacity(0.6))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.06))
    }

    // MARK: - Input Bar
    private func inputBar() -> some View {
        HStack(spacing: 8) {
            TextField("Ask \(config.preset.rawValue) anything...", text: $vm.inputText)
                .textFieldStyle(.plain)
                .font(.system(size: 12.5))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                )
                .onSubmit {
                    vm.sendCurrentMessage()
                }

            if vm.isSending {
                ProgressView()
                    .controlSize(.small)
                    .frame(width: 28, height: 28)
            } else {
                Button {
                    vm.sendCurrentMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .white.opacity(0.3) : config.colorTheme.primaryColor)
                }
                .buttonStyle(.plain)
                .disabled(vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isSending)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}
