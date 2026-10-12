import Foundation
import AppKit

public struct SystemService {
    public static let shared = SystemService()

    private init() {}

    // MARK: - Clipboard
    public func getClipboardText() -> String? {
        return NSPasteboard.general.string(forType: .string)
    }

    public func setClipboardText(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    // MARK: - Screen Capture
    public func captureActiveScreen() -> NSImage? {
        let mainDisplayID = CGMainDisplayID()
        guard let imageRef = CGDisplayCreateImage(mainDisplayID) else {
            // Fallback to screencapture CLI
            let tempPath = "/tmp/dot_screen_capture.png"
            let proc = Process()
            proc.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
            proc.arguments = ["-x", "-C", tempPath]
            try? proc.run()
            proc.waitUntilExit()
            if let image = NSImage(contentsOfFile: tempPath) {
                try? FileManager.default.removeItem(atPath: tempPath)
                return image
            }
            return nil
        }
        let size = NSSize(width: imageRef.width, height: imageRef.height)
        return NSImage(cgImage: imageRef, size: size)
    }

    // MARK: - Shell Execution
    public func executeCommand(_ command: String) async -> (stdout: String, stderr: String, exitCode: Int32) {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let process = Process()
                let stdoutPipe = Pipe()
                let stderrPipe = Pipe()

                process.executableURL = URL(fileURLWithPath: "/bin/zsh")
                process.arguments = ["-c", command]
                process.standardOutput = stdoutPipe
                process.standardError = stderrPipe

                do {
                    try process.run()
                    process.waitUntilExit()

                    let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
                    let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()

                    let stdoutStr = String(data: stdoutData, encoding: .utf8) ?? ""
                    let stderrStr = String(data: stderrData, encoding: .utf8) ?? ""
                    let exitCode = process.terminationStatus

                    continuation.resume(returning: (stdout: stdoutStr, stderr: stderrStr, exitCode: exitCode))
                } catch {
                    continuation.resume(returning: (stdout: "", stderr: error.localizedDescription, exitCode: -1))
                }
            }
        }
    }

    // MARK: - macOS Desktop Notifications
    public func postNotification(title: String, message: String) {
        let escapedTitle = title.replacingOccurrences(of: "\"", with: "\\\"")
        let escapedMsg = message.replacingOccurrences(of: "\"", with: "\\\"")
        let script = "display notification \"\(escapedMsg)\" with title \"\(escapedTitle)\" sound name \"Hero\""
        var error: NSDictionary?
        if let appleScript = NSAppleScript(source: script) {
            appleScript.executeAndReturnError(&error)
        }
    }

    // MARK: - System Volume Control
    public func setVolume(percent: Int) {
        let clamped = max(0, min(100, percent))
        let script = "set volume output volume \(clamped)"
        var error: NSDictionary?
        if let appleScript = NSAppleScript(source: script) {
            appleScript.executeAndReturnError(&error)
        }
    }

    // MARK: - Battery & System Status
    public func getBatteryStatus() -> String {
        let pipe = Pipe()
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        process.arguments = ["-g", "batt"]
        process.standardOutput = pipe

        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? "Battery info unavailable"
            return output.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            return "Unable to read battery status: \(error.localizedDescription)"
        }
    }

    // MARK: - Open Applications & URLs
    public func openApplication(name: String) -> Bool {
        let script = "tell application \"\(name)\" to activate"
        var error: NSDictionary?
        if let appleScript = NSAppleScript(source: script) {
            appleScript.executeAndReturnError(&error)
            return error == nil
        }
        return false
    }

    public func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }
}
