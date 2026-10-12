import Foundation

public struct MemoryItem: Identifiable, Codable, Equatable {
    public let id: UUID
    public var fact: String
    public var category: String
    public var timestamp: Date

    public init(id: UUID = UUID(), fact: String, category: String = "general", timestamp: Date = Date()) {
        self.id = id
        self.fact = fact
        self.category = category
        self.timestamp = timestamp
    }
}

@MainActor
public class DotMemoryService: ObservableObject {
    public static let shared = DotMemoryService()

    private let storageKey = "dot_persistent_memories_v1"

    @Published public var memories: [MemoryItem] = []

    private init() {
        loadMemories()
    }

    public func loadMemories() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let items = try? JSONDecoder().decode([MemoryItem].self, from: data) {
            self.memories = items
        } else {
            // Seed default friendly memory
            self.memories = [
                MemoryItem(fact: "Пользователь ценит теплоту, глубину ответов и детальные объяснения", category: "preferences"),
                MemoryItem(fact: "Основной проект: ИИ-компаньон Dot для рабочего стола", category: "projects")
            ]
            saveMemories()
        }
    }

    public func saveMemories() {
        if let data = try? JSONEncoder().encode(memories) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    public func addMemory(fact: String, category: String = "general") {
        let trimmed = fact.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard !memories.contains(where: { $0.fact.lowercased() == trimmed.lowercased() }) else { return }

        let item = MemoryItem(fact: trimmed, category: category)
        memories.insert(item, at: 0)
        saveMemories()
    }

    public func removeMemory(id: UUID) {
        memories.removeAll(where: { $0.id == id })
        saveMemories()
    }

    public func clearAllMemories() {
        memories.removeAll()
        saveMemories()
    }

    public func getFormattedContext() -> String {
        guard !memories.isEmpty else { return "" }
        var lines: [String] = [
            "[DOT LONG-TERM USER MEMORY & FACTS]",
            "You have learned and remember the following facts about your user from previous conversations:",
        ]
        for m in memories.prefix(15) {
            lines.append("• [\(m.category.uppercased())] \(m.fact)")
        }
        lines.append("Always personalize your tone, context, and responses naturally based on these memories.")
        return lines.joined(separator: "\n")
    }
}
