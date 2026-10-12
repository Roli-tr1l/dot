import Foundation

public enum AutonomyLevel: String, Codable, CaseIterable, Identifiable {
    case full       = "full"        // Выполнять без спроса (полная автономия)
    case askFirst   = "askFirst"    // Спрашивать разрешение перед выполнением
    case onDemand   = "onDemand"    // Только по запросу
    case disabled   = "disabled"    // Запрещено / отключено

    public var id: String { rawValue }

    public func localized(in lang: DotLanguage) -> String {
        switch lang {
        case .russian:
            switch self {
            case .full:     return "🟢 Полная автономия"
            case .askFirst: return "🟡 Спрашивать подтверждение"
            case .onDemand: return "🔵 Только по запросу"
            case .disabled: return "⛔ Отключено"
            }
        case .chinese:
            switch self {
            case .full:     return "🟢 完全自主"
            case .askFirst: return "🟡 需事先确认"
            case .onDemand: return "🔵 仅手动触发"
            case .disabled: return "⛔ 已禁用"
            }
        case .japanese:
            switch self {
            case .full:     return "🟢 完全自律"
            case .askFirst: return "🟡 実行前に確認"
            case .onDemand: return "🔵 リクエスト時のみ"
            case .disabled: return "⛔ 無効"
            }
        default:
            switch self {
            case .full:     return "🟢 Full Autonomy"
            case .askFirst: return "🟡 Ask Permission"
            case .onDemand: return "🔵 On Demand"
            case .disabled: return "⛔ Disabled"
            }
        }
    }
}

public enum GoalCategory: String, Codable, CaseIterable, Identifiable {
    case research = "research"
    case hardware = "hardware"
    case wellness = "wellness"
    case memory   = "memory"
    case custom   = "custom"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .research: return "globe.europe.africa.fill"
        case .hardware: return "bolt.batteryblock.fill"
        case .wellness: return "heart.circle.fill"
        case .memory:   return "brain.head.profile"
        case .custom:   return "sparkles"
        }
    }

    public func title(in lang: DotLanguage) -> String {
        switch lang {
        case .russian:
            switch self {
            case .research: return "Веб-исследования"
            case .hardware: return "Железо и система"
            case .wellness: return "Здоровье и фокус"
            case .memory:   return "Память и контекст"
            case .custom:   return "Пользовательское"
            }
        default:
            switch self {
            case .research: return "Web Research"
            case .hardware: return "System & Hardware"
            case .wellness: return "Wellness & Focus"
            case .memory:   return "Memory & Context"
            case .custom:   return "Custom"
            }
        }
    }
}

public struct TaskGoal: Identifiable, Codable, Equatable {
    public let id: UUID
    public var title: String
    public var prompt: String
    public var intervalSeconds: Double
    public var isEnabled: Bool
    public var autonomyLevel: AutonomyLevel
    public var category: GoalCategory
    public var lastRun: Date?
    public var lastResult: String?
    public var runCount: Int

    public init(
        id: UUID = UUID(),
        title: String,
        prompt: String,
        intervalSeconds: Double = 300,
        isEnabled: Bool = true,
        autonomyLevel: AutonomyLevel = .full,
        category: GoalCategory = .custom,
        lastRun: Date? = nil,
        lastResult: String? = nil,
        runCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.prompt = prompt
        self.intervalSeconds = intervalSeconds
        self.isEnabled = isEnabled
        self.autonomyLevel = autonomyLevel
        self.category = category
        self.lastRun = lastRun
        self.lastResult = lastResult
        self.runCount = runCount
    }
}
