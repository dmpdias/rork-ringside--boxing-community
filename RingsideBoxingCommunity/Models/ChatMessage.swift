import Foundation

struct ChatMessage: Identifiable, Sendable {
    let id: String
    let userName: String
    let text: String
    let timestamp: Date
    let isCurrentUser: Bool
    let reaction: String?
}
