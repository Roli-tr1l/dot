import Foundation

public enum ActivityType: String, Codable {
    case research   = "research"
    case hardware   = "hardware"
    case wellness   = "wellness"
    case memory     = "memory"
    case action     = "action"
    case system     = "system"

    public var icon: String {
        switch self {
        case .research: return "globe.europe.africa.fill"
        case .hardware: return "bolt.batteryblock.fill"
        case .wellness: return "heart.circle.fill"
        case .memory:   return "brain.head.profile"
        case .action:   return "terminal.fill"
        case .system:   return "gearshape.2.fill"
        }
    }
}

public struct ActivityRecord: Identifiable, Codable, Equatable {
    public let id: UUID
    public let timestamp: Date
    public let goalTitle: String
    public let summary: String
    public let fullDetails: String
    public let type: ActivityType
    public let notificationSent: Bool

    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        goalTitle: String,
        summary: String,
        fullDetails: String = "",
        type: ActivityType = .system,
        notificationSent: Bool = false
    ) {
        self.id = id
        self.timestamp = timestamp
        self.goalTitle = goalTitle
        self.summary = summary
        self.fullDetails = fullDetails
        self.type = type
        self.notificationSent = notificationSent
    }
}

@MainActor
public class ActivityLogService: ObservableObject {
    public static let shared = ActivityLogService()

    @Published public var records: [ActivityRecord] = []

    private let maxRecords = 40

    private init() {
        // Seed initial activity record
        self.records = [
            ActivityRecord(
                timestamp: Date(),
                goalTitle: "Dot Core",
                summary: "Автономный движок микро-агентов инициализирован и готов к работе",
                fullDetails: "Модели Gemini 3.8 Flash и 3.1 Pro подключены. Фоновые микро-агенты запущены.",
                type: .system,
                notificationSent: false
            )
        ]
    }

    public func log(
        goalTitle: String,
        summary: String,
        fullDetails: String = "",
        type: ActivityType = .system,
        notificationSent: Bool = false
    ) {
        let record = ActivityRecord(
            goalTitle: goalTitle,
            summary: summary,
            fullDetails: fullDetails,
            type: type,
            notificationSent: notificationSent
        )
        records.insert(record, at: 0)
        if records.count > maxRecords {
            records.removeLast()
        }
    }

    public func clear() {
        records.removeAll()
    }
}
