import Foundation
import AppKit

@MainActor
public class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?

    public func applicationDidFinishLaunching(_ notification: Notification) {
        // Run as accessory / background agent so it feels like a native floating companion
        NSApp.setActivationPolicy(.accessory)

        // Setup Floating Window
        WindowController.shared.setup()

        // Setup Menu Bar Status Item
        setupStatusItem()

        // Start Autonomous Background Goals
        BackgroundAgent.shared.start()

        // Initial Greeting
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            DotState.shared.wakeUp()
            let greeting = DotConfig.shared.language == .russian ? "Привет! Dot онлайн! ✨" : "Hi! Dot is online! ✨"
            DotState.shared.showSpeechBubble(greeting, duration: 3.0)
            SpeechService.shared.playWakeupSound()
        }
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.title = "🟣"
            button.toolTip = "Dot — macOS AI Companion"
        }

        let menu = NSMenu()
        let lang = DotConfig.shared.language

        let toggleTitle: String
        let chatTitle: String
        let screenTitle: String
        let goalsTitle: String
        let prefTitle: String
        let quitTitle: String

        switch lang {
        case .russian:
            toggleTitle = "Показать/Скрыть Dot"
            chatTitle = "Открыть чат и инструменты"
            screenTitle = "Снимок экрана"
            goalsTitle = "Автономные цели"
            prefTitle = "Настройки..."
            quitTitle = "Выйти из Dot"
        case .chinese:
            toggleTitle = "显示/隐藏 Dot"
            chatTitle = "打开聊天与工具"
            screenTitle = "截取屏幕"
            goalsTitle = "自主常驻目标"
            prefTitle = "偏好设置..."
            quitTitle = "退出 Dot"
        case .japanese:
            toggleTitle = "Dotの表示/非表示"
            chatTitle = "チャットとツールを開く"
            screenTitle = "画面をキャプチャ"
            goalsTitle = "自律目標"
            prefTitle = "環境設定..."
            quitTitle = "Dot を終了"
        default:
            toggleTitle = "Toggle Dot Avatar"
            chatTitle = "Open Chat & Tools"
            screenTitle = "Capture Screen"
            goalsTitle = "Autonomous Goals"
            prefTitle = "Preferences..."
            quitTitle = "Quit Dot"
        }

        let toggleItem = NSMenuItem(title: toggleTitle, action: #selector(toggleAvatar), keyEquivalent: "d")
        toggleItem.target = self
        menu.addItem(toggleItem)

        let chatItem = NSMenuItem(title: chatTitle, action: #selector(openChat), keyEquivalent: "c")
        chatItem.target = self
        menu.addItem(chatItem)

        let screenItem = NSMenuItem(title: screenTitle, action: #selector(captureScreen), keyEquivalent: "s")
        screenItem.target = self
        menu.addItem(screenItem)

        let goalsItem = NSMenuItem(title: goalsTitle, action: #selector(openGoals), keyEquivalent: "g")
        goalsItem.target = self
        menu.addItem(goalsItem)

        menu.addItem(NSMenuItem.separator())

        let prefItem = NSMenuItem(title: prefTitle, action: #selector(openPreferences), keyEquivalent: ",")
        prefItem.target = self
        menu.addItem(prefItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: quitTitle, action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
    }

    @objc private func toggleAvatar() {
        WindowController.shared.toggleVisibility()
    }

    @objc private func openChat() {
        WindowController.shared.showPanel()
        DotState.shared.isChatOpen = true
        DotState.shared.wakeUp()
    }

    @objc private func captureScreen() {
        WindowController.shared.showPanel()
        DotState.shared.isChatOpen = true
        DotState.shared.wakeUp()
        if let screen = SystemService.shared.captureActiveScreen() {
            DotState.shared.appendUserMessage("Here is my screen capture. What's happening?", image: screen)
            DotState.shared.setMood(.thinking)
            Task {
                if let (resp, action) = try? await GeminiService.shared.sendMessage(prompt: "Analyze this screen capture", image: screen) {
                    await MainActor.run {
                        DotState.shared.appendModelMessage(resp, action: action)
                        SpeechService.shared.speak(resp)
                    }
                }
            }
        }
    }

    @objc private func openGoals() {
        WindowController.shared.showPanel()
        DotState.shared.isGoalsOpen = true
        DotState.shared.wakeUp()
    }

    @objc private func openPreferences() {
        WindowController.shared.showPanel()
        DotState.shared.isSettingsOpen = true
        DotState.shared.wakeUp()
    }

    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
