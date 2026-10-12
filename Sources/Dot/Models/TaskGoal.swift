import Foundation

public struct TaskGoal: Identifiable, Codable, Equatable {
    public let id: UUID
    public var title: String
    public var prompt: String
    public var intervalSeconds: Double
    public var isEnabled: Bool
    public var lastRun: Date?
    public var lastResult: String?
    public var runCount: Int

    public init(
        id: UUID = UUID(),
        title: String,
        prompt: String,
        intervalSeconds: Double = 300,
        isEnabled: Bool = true,
        lastRun: Date? = nil,
        lastResult: String? = nil,
        runCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.prompt = prompt
        self.intervalSeconds = intervalSeconds
        self.isEnabled = isEnabled
        self.lastRun = lastRun
        self.lastResult = lastResult
        self.runCount = runCount
    }
}
