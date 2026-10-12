import Foundation
import SwiftUI

public struct SettingsView: View {
    @ObservedObject var config: DotConfig = DotConfig.shared
    @ObservedObject var state: DotState = DotState.shared
    @ObservedObject var vm: SettingsViewModel = SettingsViewModel.shared

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(config.language.localized(.settingsTitle))
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.3)) {
                        state.isSettingsOpen = false
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

            // Segmented Tab Picker
            Picker("", selection: $vm.selectedTab) {
                Text(config.language.localized(.tabAI)).tag(0)
                Text(config.language.localized(.tabAvatar)).tag(1)
                Text(config.language.localized(.tabVoice)).tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.bottom, 10)

            Divider()
                .background(Color.white.opacity(0.12))

            ScrollView {
                VStack(spacing: 16) {
                    if vm.selectedTab == 0 {
                        apiSettingsSection()
                    } else if vm.selectedTab == 1 {
                        avatarSettingsSection()
                    } else {
                        voiceSettingsSection()
                    }
                }
                .padding(16)
            }
        }
        .frame(width: 390, height: 490)
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

    // MARK: - Tab 0: API & AI
    private func apiSettingsSection() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            // Language Selector
            VStack(alignment: .leading, spacing: 6) {
                Text(config.language.localized(.languageLabel))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                Picker("", selection: $config.language) {
                    ForEach(DotLanguage.allCases) { lang in
                        Text(lang.displayName).tag(lang)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(config.language.localized(.apiKeyLabel))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                HStack {
                    if vm.isShowingApiKey {
                        TextField(config.language.localized(.apiKeyPlaceholder), text: $config.apiKey)
                            .textFieldStyle(.plain)
                            .foregroundColor(.white)
                    } else {
                        SecureField(config.language.localized(.apiKeyPlaceholder), text: $config.apiKey)
                            .textFieldStyle(.plain)
                            .foregroundColor(.white)
                    }

                    Button {
                        vm.isShowingApiKey.toggle()
                    } label: {
                        Image(systemName: vm.isShowingApiKey ? "eye.slash" : "eye")
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                }
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.08)))

                Button(config.language.localized(.apiKeyHelp)) {
                    SystemService.shared.openURL("https://aistudio.google.com/app/apikey")
                }
                .font(.system(size: 10.5))
                .foregroundColor(config.colorTheme.primaryColor)
                .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(config.language.localized(.modelLabel))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                Picker("", selection: $config.model) {
                    ForEach(DotConfig.availableModels, id: \.self) { m in
                        Text(m).tag(m)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Prompt / Instructions")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                TextEditor(text: $config.systemPrompt)
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .padding(6)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.08)))
                    .frame(height: 90)
            }
        }
    }

    // MARK: - Tab 1: Avatar & Presets
    private func avatarSettingsSection() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            // Live Preview
            HStack {
                Spacer()
                DotAvatarView()
                Spacer()
            }
            .padding(.vertical, 4)

            // Official ChatGPT Presets Grid
            VStack(alignment: .leading, spacing: 6) {
                Text(config.language.localized(.presetsLabel))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(DotPreset.allCases) { p in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                config.applyPreset(p)
                            }
                            SpeechService.shared.playPopSound()
                        } label: {
                            HStack(spacing: 8) {
                                Text(p.emoji)
                                    .font(.system(size: 16))
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(p.rawValue)
                                        .font(.system(size: 11.5, weight: config.preset == p ? .bold : .medium))
                                        .foregroundColor(config.preset == p ? .white : .white.opacity(0.85))
                                }
                                Spacer()
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(config.preset == p ? config.colorTheme.primaryColor.opacity(0.3) : Color.white.opacity(0.06))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(config.preset == p ? config.colorTheme.primaryColor : Color.clear, lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            Divider().background(Color.white.opacity(0.1))

            // Body Shape
            VStack(alignment: .leading, spacing: 6) {
                Text("Body Geometry")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                Picker("", selection: $config.bodyShape) {
                    ForEach(AvatarBodyShape.allCases) { shape in
                        Text(shape.rawValue).tag(shape)
                    }
                }
                .pickerStyle(.segmented)
            }

            // Color Palette
            VStack(alignment: .leading, spacing: 6) {
                Text("Color Aura")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                HStack(spacing: 8) {
                    ForEach(AvatarColorTheme.allCases) { theme in
                        Button {
                            withAnimation {
                                config.colorTheme = theme
                            }
                        } label: {
                            Circle()
                                .fill(theme.primaryColor)
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: config.colorTheme == theme ? 2.5 : 0)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            // Accessories
            VStack(alignment: .leading, spacing: 6) {
                Text("Accessory")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                Picker("", selection: $config.accessory) {
                    ForEach(AvatarAccessory.allCases) { acc in
                        Text(acc.rawValue).tag(acc)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }

            // Avatar Scale
            VStack(alignment: .leading, spacing: 6) {
                Text("Avatar Scale")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                Picker("", selection: $config.size) {
                    ForEach(AvatarSize.allCases) { s in
                        Text(s.rawValue).tag(s)
                    }
                }
                .pickerStyle(.segmented)
            }

            Toggle("Auto-sleep when inactive", isOn: $config.autoSleep)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.9))
        }
    }

    // MARK: - Tab 2: Voice & Sound
    private func voiceSettingsSection() -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Toggle(config.language.localized(.speechEnabledLabel), isOn: $config.speechEnabled)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))

            Toggle(config.language.localized(.soundEffectsLabel), isOn: $config.soundEffects)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.9))

            VStack(alignment: .leading, spacing: 6) {
                Text(config.language.localized(.voiceLabel))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                Picker("", selection: $config.voiceName) {
                    ForEach(SpeechService.availableVoiceNames, id: \.self) { v in
                        Text(v).tag(v)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(config.language.localized(.speechRateLabel))
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                    Spacer()
                    Text(String(format: "%.1fx", config.speechRate))
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(.white.opacity(0.7))
                }

                Slider(value: $config.speechRate, in: 0.7...1.5, step: 0.05)
            }

            Button("Test Voice 🔊") {
                let testPhrase: String
                switch config.language {
                case .russian:  testPhrase = "Привет! Я твой персональный компаньон Dot!"
                case .english:  testPhrase = "Hello! I am your personal Mac companion Dot!"
                case .chinese:  testPhrase = "你好！我是你的专属伴侣 Dot！"
                case .japanese: testPhrase = "こんにちは！パーソナルコンパニオンの Dot です！"
                case .spanish:  testPhrase = "¡Hola! ¡Soy Dot, tu compañero de Mac!"
                case .german:   testPhrase = "Hallo! Ich bin dein Mac-Begleiter Dot!"
                case .french:   testPhrase = "Bonjour ! Je suis Dot, votre compagnon Mac !"
                case .korean:   testPhrase = "안녕하세요! 당신의 Mac 컴패니언 Dot입니다!"
                }
                SpeechService.shared.speak(testPhrase)
            }
            .font(.system(size: 11.5))
            .foregroundColor(config.colorTheme.primaryColor)
            .buttonStyle(.plain)
        }
    }
}
