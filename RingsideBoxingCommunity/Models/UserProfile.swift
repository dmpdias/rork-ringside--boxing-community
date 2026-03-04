import Foundation

struct Badge: Identifiable, Sendable {
    let id: String
    let name: String
    let icon: String
    let color: String
    let progress: Double
}

struct ActivityItem: Identifiable, Sendable {
    let id: String
    let type: ActivityType
    let title: String
    let subtitle: String
    let timestamp: Date
}

nonisolated enum ActivityType: Sendable {
    case scorecard
    case post
    case badge
}

struct UserProfile: Sendable {
    let displayName: String
    let username: String
    let avatarEmoji: String
    let followers: Int
    let following: Int
    let fightsScored: Int
    let averageRating: Double
    let posts: Int
    let badges: [Badge]
    let recentActivity: [ActivityItem]
}
