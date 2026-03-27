import Foundation

struct FightInteraction: Identifiable, Sendable {
    let id: String
    let fightId: String
    var userRating: Double?
    var userComment: String?
    var thumbsUp: Int
    var thumbsDown: Int
    var hasThumbedUp: Bool
    var hasThumbedDown: Bool
    var communityComments: [FightComment]
}

struct FightComment: Identifiable, Sendable {
    let id: String
    let userName: String
    let avatarEmoji: String
    let text: String
    let timestamp: Date
}
