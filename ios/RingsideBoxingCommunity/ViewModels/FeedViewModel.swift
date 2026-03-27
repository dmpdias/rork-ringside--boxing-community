import SwiftUI

@Observable
class FeedViewModel {
    var interactions: [String: FightInteraction] = RealBoxingData.interactionsForFights()
    var showingCommentSheet: Bool = false
    var activeCommentFightId: String?
    var newCommentText: String = ""
    var showingRatingSheet: Bool = false
    var activeRatingFightId: String?
    var ratingDraft: Double = 5.0
    var ratingCommentDraft: String = ""
    var selectedTab: Int = 0

    var dataEvents: [Event] = RealBoxingData.allEvents

    var allFightsWithContext: [(fight: Fight, eventName: String, venue: String)] {
        dataEvents.flatMap { event in
            event.fights.map { (fight: $0, eventName: event.name, venue: event.venue) }
        }
    }

    func toggleThumbsUp(fightId: String) {
        guard var interaction = interactions[fightId] else { return }
        if interaction.hasThumbedUp {
            interaction.thumbsUp -= 1
            interaction.hasThumbedUp = false
        } else {
            interaction.thumbsUp += 1
            interaction.hasThumbedUp = true
            if interaction.hasThumbedDown {
                interaction.thumbsDown -= 1
                interaction.hasThumbedDown = false
            }
        }
        interactions[fightId] = interaction
    }

    func toggleThumbsDown(fightId: String) {
        guard var interaction = interactions[fightId] else { return }
        if interaction.hasThumbedDown {
            interaction.thumbsDown -= 1
            interaction.hasThumbedDown = false
        } else {
            interaction.thumbsDown += 1
            interaction.hasThumbedDown = true
            if interaction.hasThumbedUp {
                interaction.thumbsUp -= 1
                interaction.hasThumbedUp = false
            }
        }
        interactions[fightId] = interaction
    }

    func addComment(fightId: String) {
        guard !newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard var interaction = interactions[fightId] else { return }
        let comment = FightComment(
            id: "fc_\(fightId)_\(Int.random(in: 1000...9999))",
            userName: "You",
            avatarEmoji: "🥊",
            text: newCommentText.trimmingCharacters(in: .whitespacesAndNewlines),
            timestamp: Date()
        )
        interaction.communityComments.append(comment)
        interactions[fightId] = interaction
        newCommentText = ""
    }

    func submitRating(fightId: String) {
        guard var interaction = interactions[fightId] else { return }
        interaction.userRating = ratingDraft
        if !ratingCommentDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            interaction.userComment = ratingCommentDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        interactions[fightId] = interaction
        ratingDraft = 5.0
        ratingCommentDraft = ""
    }

    func openRating(fightId: String) {
        activeRatingFightId = fightId
        if let existing = interactions[fightId]?.userRating {
            ratingDraft = existing
        } else {
            ratingDraft = 5.0
        }
        if let existingComment = interactions[fightId]?.userComment {
            ratingCommentDraft = existingComment
        } else {
            ratingCommentDraft = ""
        }
        showingRatingSheet = true
    }

    func openComments(fightId: String) {
        activeCommentFightId = fightId
        newCommentText = ""
        showingCommentSheet = true
    }
}
