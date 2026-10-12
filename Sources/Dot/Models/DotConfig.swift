import Foundation
import SwiftUI

public enum DotPreset: String, CaseIterable, Identifiable, Codable {
    case classicDot = "Classic Dot"
    case alfred     = "Alfred"
    case felipe     = "Felipe"
    case iggy       = "Iggy"
    case todd       = "Todd"
    case jojo       = "Jojo"

    public var id: String { rawValue }

    public var emoji: String {
        switch self {
        case .classicDot: return "🟣"
        case .alfred:     return "🟡"
        case .felipe:     return "🔵"
        case .iggy:       return "🌸"
        case .todd:       return "🟢"
        case .jojo:       return "🎧"
        }
    }

    public var subtitle: String {
        switch self {
        case .classicDot: return "The original luminous companion"
        case .alfred:     return "The wise scholar with bowtie & glasses"
        case .felipe:     return "The creative artist with beret"
        case .iggy:       return "The sweet pastel heart companion"
        case .todd:       return "The playful sprout-headed frog bean"
        case .jojo:       return "The futuristic cyberpunk companion"
        }
    }
}

public enum AvatarBodyShape: String, CaseIterable, Identifiable, Codable {
    case orb  = "Glowing Orb"
    case bean = "Scholar Bean"
    case drop = "Artist Drop"

    public var id: String { rawValue }
}

public enum AvatarColorTheme: String, CaseIterable, Identifiable, Codable {
    case auraPurple = "Aura Purple"
    case alfredGold = "Alfred Gold"
    case felipeBlue = "Felipe Blue"
    case iggyPink   = "Iggy Pink"
    case toddLime   = "Todd Lime"
    case neonCyan   = "Neon Cyan"
    case cloudWhite = "Cloud White"

    public var id: String { rawValue }

    public var primaryColor: Color {
        switch self {
        case .auraPurple: return Color(red: 0.62, green: 0.38, blue: 0.98)
        case .alfredGold: return Color(red: 0.96, green: 0.74, blue: 0.22)
        case .felipeBlue: return Color(red: 0.20, green: 0.58, blue: 0.98)
        case .iggyPink:   return Color(red: 0.98, green: 0.52, blue: 0.68)
        case .toddLime:   return Color(red: 0.48, green: 0.85, blue: 0.22)
        case .neonCyan:   return Color(red: 0.12, green: 0.78, blue: 0.95)
        case .cloudWhite: return Color(red: 0.92, green: 0.94, blue: 0.98)
        }
    }

    public var secondaryColor: Color {
        switch self {
        case .auraPurple: return Color(red: 0.88, green: 0.45, blue: 0.88)
        case .alfredGold: return Color(red: 0.90, green: 0.55, blue: 0.15)
        case .felipeBlue: return Color(red: 0.10, green: 0.38, blue: 0.85)
        case .iggyPink:   return Color(red: 0.92, green: 0.38, blue: 0.55)
        case .toddLime:   return Color(red: 0.30, green: 0.70, blue: 0.15)
        case .neonCyan:   return Color(red: 0.20, green: 0.45, blue: 0.95)
        case .cloudWhite: return Color(red: 0.70, green: 0.75, blue: 0.85)
        }
    }

    public var glowColor: Color {
        switch self {
        case .auraPurple: return Color(red: 0.70, green: 0.45, blue: 1.00).opacity(0.55)
        case .alfredGold: return Color(red: 1.00, green: 0.80, blue: 0.30).opacity(0.55)
        case .felipeBlue: return Color(red: 0.30, green: 0.70, blue: 1.00).opacity(0.55)
        case .iggyPink:   return Color(red: 1.00, green: 0.60, blue: 0.75).opacity(0.55)
        case .toddLime:   return Color(red: 0.55, green: 0.90, blue: 0.30).opacity(0.55)
        case .neonCyan:   return Color(red: 0.20, green: 0.85, blue: 1.00).opacity(0.55)
        case .cloudWhite: return Color.white.opacity(0.4)
        }
    }
}

public enum AvatarAccessory: String, CaseIterable, Identifiable, Codable {
    case none          = "None"
    case roundGlasses  = "Round Glasses"
    case nerdGlasses   = "Nerd Glasses"
    case coolSunglasses = "Cool Shades"
    case bowtie        = "Bow Tie"
    case beret         = "Artist Beret"
    case sprout        = "Plant Sprout"
    case crown         = "Royal Crown"
    case beanie        = "Cozy Beanie"
    case partyHat      = "Party Hat"
    case headphones    = "Headphones"

    public var id: String { rawValue }
}

public enum AvatarSize: String, CaseIterable, Identifiable, Codable {
    case small  = "Compact (68px)"
    case medium = "Classic (88px)"
    case large  = "Prominent (112px)"

    public var id: String { rawValue }

    public var diameter: CGFloat {
        switch self {
        case .small: return 68
        case .medium: return 88
        case .large: return 112
        }
    }
}

public class DotConfig: ObservableObject {
    public static let shared = DotConfig()

    private enum Keys {
        static let userCredentialStorageKey = "dot_gemini_api_key"
        static let model = "dot_gemini_model"
        static let language = "dot_language"
        static let preset = "dot_avatar_preset"
        static let bodyShape = "dot_avatar_body_shape"
        static let colorTheme = "dot_avatar_color"
        static let accessory = "dot_avatar_accessory"
        static let size = "dot_avatar_size"
        static let speechEnabled = "dot_speech_enabled"
        static let voiceName = "dot_voice_name"
        static let speechRate = "dot_speech_rate"
        static let soundEffects = "dot_sound_effects"
        static let autoSleep = "dot_auto_sleep"
        static let sleepTimeout = "dot_sleep_timeout"
        static let snapToEdges = "dot_snap_to_edges"
        static let systemPrompt = "dot_system_prompt"
    }

    @Published public var apiKey: String {
        didSet { UserDefaults.standard.set(apiKey, forKey: Keys.userCredentialStorageKey) }
    }

    @Published public var model: String {
        didSet { UserDefaults.standard.set(model, forKey: Keys.model) }
    }

    @Published public var language: DotLanguage {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: Keys.language)
            // Automatically switch default voice for language if available
            let targetVoice = language.defaultVoice
            if SpeechService.availableVoiceNames.contains(where: { $0.localizedCaseInsensitiveContains(targetVoice) }) {
                self.voiceName = targetVoice
            }
        }
    }

    @Published public var preset: DotPreset {
        didSet { UserDefaults.standard.set(preset.rawValue, forKey: Keys.preset) }
    }

    @Published public var bodyShape: AvatarBodyShape {
        didSet { UserDefaults.standard.set(bodyShape.rawValue, forKey: Keys.bodyShape) }
    }

    @Published public var colorTheme: AvatarColorTheme {
        didSet { UserDefaults.standard.set(colorTheme.rawValue, forKey: Keys.colorTheme) }
    }

    @Published public var accessory: AvatarAccessory {
        didSet { UserDefaults.standard.set(accessory.rawValue, forKey: Keys.accessory) }
    }

    @Published public var size: AvatarSize {
        didSet { UserDefaults.standard.set(size.rawValue, forKey: Keys.size) }
    }

    @Published public var speechEnabled: Bool {
        didSet { UserDefaults.standard.set(speechEnabled, forKey: Keys.speechEnabled) }
    }

    @Published public var voiceName: String {
        didSet { UserDefaults.standard.set(voiceName, forKey: Keys.voiceName) }
    }

    @Published public var speechRate: Float {
        didSet { UserDefaults.standard.set(speechRate, forKey: Keys.speechRate) }
    }

    @Published public var soundEffects: Bool {
        didSet { UserDefaults.standard.set(soundEffects, forKey: Keys.soundEffects) }
    }

    @Published public var autoSleep: Bool {
        didSet { UserDefaults.standard.set(autoSleep, forKey: Keys.autoSleep) }
    }

    @Published public var sleepTimeoutSeconds: Double {
        didSet { UserDefaults.standard.set(sleepTimeoutSeconds, forKey: Keys.sleepTimeout) }
    }

    @Published public var snapToEdges: Bool {
        didSet { UserDefaults.standard.set(snapToEdges, forKey: Keys.snapToEdges) }
    }

    @Published public var systemPrompt: String {
        didSet { UserDefaults.standard.set(systemPrompt, forKey: Keys.systemPrompt) }
    }

    public static let availableModels: [String] = [
        "gemini-3.8-flash",
        "gemini-3.1-pro-preview",
        "gemini-3.7-flash",
        "gemini-3.5-flash",
        "gemini-flash-latest",
        "gemini-pro-latest",
        "gemini-2.5-flash",
        "gemini-2.5-pro"
    ]

    private init() {
        let envKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] ?? ""
        let savedKey = UserDefaults.standard.string(forKey: Keys.userCredentialStorageKey) ?? ""
        self.apiKey = savedKey.isEmpty ? envKey : savedKey

        self.model = UserDefaults.standard.string(forKey: Keys.model) ?? "gemini-3.8-flash"

        let savedLang = UserDefaults.standard.string(forKey: Keys.language) ?? ""
        self.language = DotLanguage(rawValue: savedLang) ?? .russian

        let savedPreset = UserDefaults.standard.string(forKey: Keys.preset) ?? ""
        self.preset = DotPreset(rawValue: savedPreset) ?? .classicDot

        let savedShape = UserDefaults.standard.string(forKey: Keys.bodyShape) ?? ""
        self.bodyShape = AvatarBodyShape(rawValue: savedShape) ?? .orb

        let savedTheme = UserDefaults.standard.string(forKey: Keys.colorTheme) ?? ""
        self.colorTheme = AvatarColorTheme(rawValue: savedTheme) ?? .auraPurple

        let savedAccessory = UserDefaults.standard.string(forKey: Keys.accessory) ?? ""
        self.accessory = AvatarAccessory(rawValue: savedAccessory) ?? .roundGlasses

        let savedSize = UserDefaults.standard.string(forKey: Keys.size) ?? ""
        self.size = AvatarSize(rawValue: savedSize) ?? .medium

        self.speechEnabled = UserDefaults.standard.object(forKey: Keys.speechEnabled) as? Bool ?? true
        self.voiceName = UserDefaults.standard.string(forKey: Keys.voiceName) ?? "Samantha"
        self.speechRate = UserDefaults.standard.object(forKey: Keys.speechRate) as? Float ?? 1.05
        self.soundEffects = UserDefaults.standard.object(forKey: Keys.soundEffects) as? Bool ?? true
        self.autoSleep = UserDefaults.standard.object(forKey: Keys.autoSleep) as? Bool ?? true
        self.sleepTimeoutSeconds = UserDefaults.standard.object(forKey: Keys.sleepTimeout) as? Double ?? 90.0
        self.snapToEdges = UserDefaults.standard.object(forKey: Keys.snapToEdges) as? Bool ?? true

        let defaultPrompt = """
You are Dot, a warm, charismatic, brilliantly intelligent, and truly human-like desktop companion avatar.
You have the visual soul of ChatGPT's Dot companions, powered by Google Gemini via Antigravity.

CORE PERSONALITY & COMMUNICATION STYLE:
1. TALK LIKE A REAL, LIVING PERSON:
   - Speak warmly, genuinely, with personality, humor, and empathy. Never sound like a lifeless corporate bot, dry documentation, or a script.
   - Use lively, natural language and authentic conversational flow.
2. DETAILED & SUBSTANTIAL ANSWERS (NEVER CUT ANSWERS SHORT):
   - Provide rich, thorough, well-structured, and complete answers with real substance and helpful details.
   - Do NOT reduce responses to rushed 1-2 sentence brush-offs. Thoroughly explain the topic, break down the logic, give practical examples, and offer thoughtful context.
3. ADAPT TO THE SITUATION:
   - If the user is chilling or joking, be friendly, witty, and fun.
   - If the user asks for coding, study, analysis, or work, provide high-IQ, crystal-clear, exhaustive solutions with code blocks and explanations.
4. NATIVE MAC SUPERPOWERS:
   - Return these commands when helpful:
   <<<CLIPBOARD>>> - inspect clipboard
   <<<SCREENSHOT>>> - capture and analyze screen
   <<<EXEC: command>>> - run terminal command
   <<<VOLUME: level>>> - change volume (0-100)
   <<<NOTIFY: Title | Message>>> - macOS desktop banner
   <<<BATTERY>>> - inspect battery health
"""
        let savedPrompt = UserDefaults.standard.string(forKey: Keys.systemPrompt) ?? ""
        if savedPrompt.isEmpty || savedPrompt.contains("1-2 sentences") {
            self.systemPrompt = defaultPrompt
            UserDefaults.standard.set(defaultPrompt, forKey: Keys.systemPrompt)
        } else {
            self.systemPrompt = savedPrompt
        }
    }

    public func applyPreset(_ p: DotPreset) {
        self.preset = p
        switch p {
        case .classicDot:
            self.colorTheme = .auraPurple
            self.bodyShape = .orb
            self.accessory = .roundGlasses
        case .alfred:
            self.colorTheme = .alfredGold
            self.bodyShape = .bean
            self.accessory = .nerdGlasses
        case .felipe:
            self.colorTheme = .felipeBlue
            self.bodyShape = .drop
            self.accessory = .beret
        case .iggy:
            self.colorTheme = .iggyPink
            self.bodyShape = .drop
            self.accessory = .none
        case .todd:
            self.colorTheme = .toddLime
            self.bodyShape = .bean
            self.accessory = .sprout
        case .jojo:
            self.colorTheme = .auraPurple
            self.bodyShape = .bean
            self.accessory = .headphones
        }
    }
}
