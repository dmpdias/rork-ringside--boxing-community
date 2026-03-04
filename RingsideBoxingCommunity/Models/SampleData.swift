import Foundation

struct SampleData {
    static let events: [Event] = RealBoxingData.allEvents

    static let samplePosts: [Post] = RealBoxingData.samplePosts

    static func highlightForDate(_ date: Date) -> FighterHighlight? {
        RealBoxingData.highlightForDate(date)
    }

    static func interactionsForFights() -> [String: FightInteraction] {
        RealBoxingData.interactionsForFights()
    }

    static let sampleRoundScores: [RoundScore] = (1...7).map { round in
        RoundScore(
            id: "rs\(round)",
            round: round,
            fighterAScore: [10, 10, 9, 10, 10, 9, 10][round - 1],
            fighterBScore: [9, 9, 10, 9, 10, 10, 9][round - 1],
            communityAScore: [9.6, 9.7, 9.2, 9.8, 9.5, 9.1, 9.6][round - 1],
            communityBScore: [9.3, 9.1, 9.7, 9.0, 9.4, 9.8, 9.2][round - 1]
        )
    }

    static let caneloStats = FighterStats(power: 0.88, precision: 0.82, combinations: 0.75, defense: 0.91, ringGeneralship: 0.87, stamina: 0.79)
    static let benavidezStats = FighterStats(power: 0.92, precision: 0.74, combinations: 0.88, defense: 0.71, ringGeneralship: 0.68, stamina: 0.85)

    static let sampleChatMessages: [ChatMessage] = [
        ChatMessage(id: "c1", userName: "BoxingFanatic99", text: "Garcia's jab was unstoppable tonight", timestamp: Date().addingTimeInterval(-120), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c2", userName: "RingSideKing", text: "Figueroa's left hook in R12 was the punch of the year", timestamp: Date().addingTimeInterval(-95), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c3", userName: "You", text: "Shakur made it look easy against Teofimo", timestamp: Date().addingTimeInterval(-80), isCurrentUser: true, reaction: nil),
        ChatMessage(id: "c4", userName: "FightNightMike", text: "Fundora vs Thurman is going to be a banger", timestamp: Date().addingTimeInterval(-60), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c5", userName: "UndercardHunter", text: "Emiliano Vargas is the next big thing. Remember the name.", timestamp: Date().addingTimeInterval(-45), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c6", userName: "BoxingFanatic99", text: "Fury coming back at Tottenham! Can't wait!", timestamp: Date().addingTimeInterval(-30), isCurrentUser: false, reaction: "🔥"),
        ChatMessage(id: "c7", userName: "JudgeScorecards", text: "Navarrete unified the belts. What a performance.", timestamp: Date().addingTimeInterval(-15), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c8", userName: "You", text: "Opetaia vs Glanton this Saturday — who's watching?", timestamp: Date().addingTimeInterval(-5), isCurrentUser: true, reaction: nil),
    ]

    static let userProfile = UserProfile(
        displayName: "Alex Johnson",
        username: "@alexringside",
        avatarEmoji: "🥊",
        followers: 1_243,
        following: 387,
        fightsScored: 89,
        averageRating: 4.6,
        posts: 34,
        badges: [
            Badge(id: "b1", name: "Analyst", icon: "chart.bar.fill", color: "gold", progress: 1.0),
            Badge(id: "b2", name: "Scout", icon: "binoculars.fill", color: "blue", progress: 0.75),
            Badge(id: "b3", name: "Matchmaker", icon: "person.2.fill", color: "red", progress: 0.45),
            Badge(id: "b4", name: "Veteran", icon: "star.fill", color: "purple", progress: 0.9),
        ],
        recentActivity: [
            ActivityItem(id: "a1", type: .scorecard, title: "Rated Garcia vs Barrios", subtitle: "8.8/10 — Garcia dominated", timestamp: Date().addingTimeInterval(-600)),
            ActivityItem(id: "a2", type: .post, title: "Posted in Community", subtitle: "\"Figueroa's R12 KO was the upset of the year\"", timestamp: Date().addingTimeInterval(-3600)),
            ActivityItem(id: "a3", type: .badge, title: "Earned Analyst Badge", subtitle: "Scored 50+ fights accurately", timestamp: Date().addingTimeInterval(-86400)),
            ActivityItem(id: "a4", type: .scorecard, title: "Rated Stevenson vs Lopez", subtitle: "8.2/10 — Shakur's defense was elite", timestamp: Date().addingTimeInterval(-172800)),
        ]
    )
}
