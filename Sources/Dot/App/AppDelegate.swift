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
            DotState.shared.showSpeechBubble("Hi! Dot is online! ✨", duration: 3.0)
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

        let toggleItem = NSMenuItem(title: "Toggle Dot Avatar", action: #selector(toggleAvatar), keyEquivalent: "d")
        toggleItem.target = self
        menu.addItem(toggleItem)

        let chatItem = NSMenuItem(title: "Open Chat & Tools", action: #selector(openChat), keyEquivalent: "c")
        chatItem.target = self
        menu.addItem(chatItem)

        let screenItem = NSMenuItem(title: "Capture Screen", action: #selector(captureScreen), keyEquivalent: "s")
        screenItem.target = self
        menu.addItem(screenItem)

        let goalsItem = NSMenuItem(title: "Autonomous Goals", action: #selector(openGoals), keyEquivalent: "g")
        goalsItem.target = self
        menu.addItem(goalsItem)

        menu.addItem(NSMenuItem.separator())

        let prefItem = NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: ",")
        prefItem.target = self
        menu.addItem(prefItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit Dot", action: #selector(quitApp), keyEquivalent: "q")
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
