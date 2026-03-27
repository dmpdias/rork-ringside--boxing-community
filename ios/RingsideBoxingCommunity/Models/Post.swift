import Foundation

struct Post: Identifiable, Sendable {
    let id: String
    let userName: String
    let userHandle: String
    let avatarEmoji: String
    let badges: [String]
    let fightContext: String?
    let text: String
    let likes: Int
    let comments: Int
    let timestamp: Date
    var isLiked: Bool
}
