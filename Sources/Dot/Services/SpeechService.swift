import Foundation
import AppKit

public class SpeechService: NSObject, ObservableObject, NSSpeechSynthesizerDelegate {
    public static let shared = SpeechService()

    private var synthesizer: NSSpeechSynthesizer?
    @Published public var isSpeaking: Bool = false

    private override init() {
        super.init()
        self.synthesizer = NSSpeechSynthesizer()
        self.synthesizer?.delegate = self
    }

    public func speak(_ text: String) {
        guard DotConfig.shared.speechEnabled else { return }

        stop()

        // Clean markdown, code blocks, and system commands from speech
        let cleaned = cleanTextForSpeech(text)
        guard !cleaned.isEmpty else { return }

        if let voice = NSSpeechSynthesizer.availableVoices.first(where: {
            $0.rawValue.localizedCaseInsensitiveContains(DotConfig.shared.voiceName)
        }) {
            synthesizer?.setVoice(voice)
        }

        synthesizer?.rate = Float(DotConfig.shared.speechRate * 180.0)

        isSpeaking = true
        Task { @MainActor in
            DotState.shared.setMood(.speaking)
        }
        synthesizer?.startSpeaking(cleaned)
    }

    public func stop() {
        if synthesizer?.isSpeaking == true {
            synthesizer?.stopSpeaking()
        }
        isSpeaking = false
    }

    public func playPopSound() {
        guard DotConfig.shared.soundEffects else { return }
        NSSound(named: "Pop")?.play()
    }

    public func playSuccessSound() {
        guard DotConfig.shared.soundEffects else { return }
        NSSound(named: "Glass")?.play()
    }

    public func playWakeupSound() {
        guard DotConfig.shared.soundEffects else { return }
        NSSound(named: "Tink")?.play()
    }

    // MARK: - NSSpeechSynthesizerDelegate
    public func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking success: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isSpeaking = false
            if DotState.shared.mood == .speaking {
                DotState.shared.setMood(.idle)
            }
        }
    }

    private func cleanTextForSpeech(_ raw: String) -> String {
        var text = raw
        // Remove code blocks
        text = text.replacingOccurrences(of: "```[\\s\\S]*?```", with: " (code snippet) ", options: .regularExpression)
        // Remove inline commands
        text = text.replacingOccurrences(of: "<<<[\\s\\S]*?>>>", with: "", options: .regularExpression)
        // Remove markdown formatting
        text = text.replacingOccurrences(of: "[#*`_~]", with: "", options: .regularExpression)
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public static var availableVoiceNames: [String] {
        return NSSpeechSynthesizer.availableVoices.map { voice in
            voice.rawValue.components(separatedBy: ".").last ?? voice.rawValue
        }
    }
}
