import SwiftUI

@Observable
class FightDetailViewModel {
    let fight: Fight

    var overallRating: Double = 0
    var selectedTags: Set<FightTag> = []
    var roundRatings: [Int: UserRoundRating] = [:]
    var isFavorite: Bool = false
    var isAddedToLog: Bool = false

    var hasPredicted: Bool = false
    var predictedWinner: String?
    var predictedMethod: PredictionMethod?
    var predictedRoundRange: String?

    var showPredictionSheet: Bool = false
    var showRoundRatingSheet: Bool = false
    var showDiscussionModal: Bool = false
    var showShareSheet: Bool = false
    var activeRoundForRating: Int = 1
    var roundRatingDraft: Double = 5.0
    var roundTagsDraft: Set<RoundTag> = []

    var discussionComments: [DiscussionComment] = []
    var discussionTab: DiscussionTab = .top
    var newCommentText: String = ""
    var visibleCommentCount: Int = 5

    var carouselIndex: Int = 0
    var carouselPaused: Bool = false

    var predictionWinnerDraft: String = ""
    var predictionMethodDraft: PredictionMethod = .ko
    var predictionRoundDraft: String = "1-3"

    init(fight: Fight) {
        self.fight = fight
        self.predictionWinnerDraft = fight.fighterA.name
        self.discussionComments = Self.generateSampleComments(for: fight)
    }

    var phase: FightPhase { fight.status.phase }

    var hasRatedOverall: Bool { overallRating > 0 }

    var scoredRoundCount: Int { roundRatings.count }

    var canSaveCard: Bool { hasRatedOverall && scoredRoundCount >= 6 }

    var cardButtonLabel: String {
        if canSaveCard { return "Save Card" }
        if hasRatedOverall || scoredRoundCount > 0 { return "Edit Card" }
        return "Rate Match"
    }

    var unofficialScore: String? {
        guard phase == .live, !roundRatings.isEmpty else { return nil }
        var scoreA = 0.0
        var scoreB = 0.0
        for (_, rating) in roundRatings {
            scoreA += rating.score
            scoreB += (10.0 - rating.score + 5.0).clamped(to: 5...10)
        }
        let nameA = fight.fighterA.name.components(separatedBy: " ").last ?? ""
        return "\(Int(scoreA))–\(Int(scoreB)) \(nameA) (your card)"
    }

    var countdownText: String? {
        guard phase == .pre, let start = fight.startTime else { return nil }
        let diff = start.timeIntervalSince(Date())
        guard diff > 0 else { return nil }
        let hours = Int(diff) / 3600
        let minutes = (Int(diff) % 3600) / 60
        if hours > 0 {
            return "Starts in \(hours)h \(minutes)m"
        }
        return "Starts in \(minutes)m"
    }

    var carouselComments: [DiscussionComment] {
        let filtered: [DiscussionComment]
        switch phase {
        case .pre:
            filtered = discussionComments.filter(\.isPrediction)
        case .live:
            filtered = discussionComments
        case .post:
            filtered = discussionComments.filter { !$0.isPrediction }
        }
        return Array(filtered.prefix(8))
    }

    var carouselLabel: String {
        switch phase {
        case .pre: return "PREDICTIONS"
        case .live: return "LIVE TAKES"
        case .post: return "REVIEWS"
        }
    }

    var sortedDiscussion: [DiscussionComment] {
        switch discussionTab {
        case .top:
            return discussionComments.sorted { $0.thumbsUp > $1.thumbsUp }
        case .recent:
            return discussionComments.sorted { $0.timestamp > $1.timestamp }
        }
    }

    var visibleDiscussion: [DiscussionComment] {
        Array(sortedDiscussion.prefix(visibleCommentCount))
    }

    var canLoadMore: Bool { visibleCommentCount < sortedDiscussion.count }

    func loadMoreComments() {
        visibleCommentCount += 5
    }

    func openRoundRating(_ round: Int) {
        activeRoundForRating = round
        if let existing = roundRatings[round] {
            roundRatingDraft = existing.score
            roundTagsDraft = existing.tags
        } else {
            roundRatingDraft = 5.0
            roundTagsDraft = []
        }
        showRoundRatingSheet = true
    }

    func saveRoundRating() {
        roundRatings[activeRoundForRating] = UserRoundRating(
            round: activeRoundForRating,
            score: roundRatingDraft,
            tags: roundTagsDraft
        )
        showRoundRatingSheet = false
    }

    func submitPrediction() {
        predictedWinner = predictionWinnerDraft
        predictedMethod = predictionMethodDraft
        predictedRoundRange = predictionRoundDraft
        hasPredicted = true
        showPredictionSheet = false
    }

    func toggleDiscussionThumbsUp(_ id: String) {
        guard let idx = discussionComments.firstIndex(where: { $0.id == id }) else { return }
        if discussionComments[idx].hasThumbedUp {
            discussionComments[idx].thumbsUp -= 1
            discussionComments[idx].hasThumbedUp = false
        } else {
            discussionComments[idx].thumbsUp += 1
            discussionComments[idx].hasThumbedUp = true
            if discussionComments[idx].hasThumbedDown {
                discussionComments[idx].thumbsDown -= 1
                discussionComments[idx].hasThumbedDown = false
            }
        }
    }

    func toggleDiscussionThumbsDown(_ id: String) {
        guard let idx = discussionComments.firstIndex(where: { $0.id == id }) else { return }
        if discussionComments[idx].hasThumbedDown {
            discussionComments[idx].thumbsDown -= 1
            discussionComments[idx].hasThumbedDown = false
        } else {
            discussionComments[idx].thumbsDown += 1
            discussionComments[idx].hasThumbedDown = true
            if discussionComments[idx].hasThumbedUp {
                discussionComments[idx].thumbsUp -= 1
                discussionComments[idx].hasThumbedUp = false
            }
        }
    }

    func addComment() {
        let trimmed = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let comment = DiscussionComment(
            id: "dc_\(UUID().uuidString)",
            userName: "You",
            text: trimmed,
            timestamp: Date(),
            thumbsUp: 0,
            thumbsDown: 0,
            hasThumbedUp: false,
            hasThumbedDown: false,
            isPrediction: phase == .pre
        )
        discussionComments.insert(comment, at: 0)
        newCommentText = ""
    }

    func isRoundTappable(_ round: Int) -> Bool {
        switch phase {
        case .pre: return false
        case .live: return round <= (fight.currentRound ?? 0)
        case .post: return true
        }
    }

    private static func generateSampleComments(for fight: Fight) -> [DiscussionComment] {
        let predictions = [
            ("BoxingFanatic99", "\(fight.fighterA.name.components(separatedBy: " ").last ?? "") by late KO, his power is unmatched", true),
            ("RingSideKing", "\(fight.fighterB.name.components(separatedBy: " ").last ?? "") on points. Better cardio.", true),
            ("FightNightMike", "I think this goes the distance. Decision for \(fight.fighterA.name.components(separatedBy: " ").last ?? "")", true),
            ("UndercardHunter", "Upset alert! \(fight.fighterB.name.components(separatedBy: " ").last ?? "") has the tools.", true),
        ]
        let reviews = [
            ("JudgeScorecards", "R7 was a robbery round, clearly \(fight.fighterA.name.components(separatedBy: " ").last ?? "")'s", false),
            ("BoxingFanatic99", "What a war! Both fighters showed heart", false),
            ("FightNightMike", "The body work in the middle rounds was the difference maker", false),
            ("RingSideKing", "Technical masterclass in the championship rounds", false),
            ("UndercardHunter", "That uppercut in the 5th was the shot of the night", false),
            ("JudgeScorecards", "I had it closer than the official cards honestly", false),
        ]
        let all = predictions + reviews
        return all.enumerated().map { i, item in
            DiscussionComment(
                id: "dc_\(fight.id)_\(i)",
                userName: item.0,
                text: item.1,
                timestamp: Date().addingTimeInterval(Double(-i * 300 - Int.random(in: 60...600))),
                thumbsUp: Int.random(in: 3...120),
                thumbsDown: Int.random(in: 0...12),
                hasThumbedUp: false,
                hasThumbedDown: false,
                isPrediction: item.2
            )
        }
    }
}

nonisolated enum DiscussionTab: String, CaseIterable, Sendable {
    case top = "Top"
    case recent = "Recent"
}

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
