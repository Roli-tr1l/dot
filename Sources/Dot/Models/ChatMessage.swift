import Foundation
import AppKit

public struct ActionRecord: Identifiable, Codable {
    public let id: UUID
    public let command: String
    public let output: String
    public let isSuccess: Bool
    public let timestamp: Date

    public init(id: UUID = UUID(), command: String, output: String, isSuccess: Bool, timestamp: Date = Date()) {
        self.id = id
        self.command = command
        self.output = output
        self.isSuccess = isSuccess
        self.timestamp = timestamp
    }
}

public struct ChatMessage: Identifiable, Equatable {
    public let id: UUID
    public let role: Role
    public var text: String
    public var image: NSImage?
    public var action: ActionRecord?
    public let timestamp: Date

    public enum Role: String, Codable {
        case user
        case model
        case system
    }

    public init(id: UUID = UUID(), role: Role, text: String, image: NSImage? = nil, action: ActionRecord? = nil, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.text = text
        self.image = image
        self.action = action
        self.timestamp = timestamp
    }

    public static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id && lhs.text == rhs.text && lhs.role == rhs.role
    }
}
