import Foundation

nonisolated enum FightPhase: String, Sendable, CaseIterable {
    case pre = "PRE"
    case live = "LIVE"
    case post = "POST"
}

nonisolated enum FightStatus: String, Sendable, CaseIterable {
    case live = "Live"
    case upcoming = "Upcoming"
    case completed = "Completed"

    var displayLabel: String {
        switch self {
        case .live: return "Live"
        case .upcoming: return "Upcoming"
        case .completed: return "Finished"
        }
    }

    var phase: FightPhase {
        switch self {
        case .upcoming: return .pre
        case .live: return .live
        case .completed: return .post
        }
    }
}

nonisolated enum CardSection: String, Sendable, CaseIterable {
    case mainCard = "Main Card"
    case undercard = "Undercard"
    case prelims = "Prelims"
}

nonisolated enum WeightClass: String, Sendable {
    case heavyweight = "Heavyweight"
    case cruiserweight = "Cruiserweight"
    case lightHeavyweight = "Light Heavyweight"
    case superMiddleweight = "Super Middleweight"
    case middleweight = "Middleweight"
    case superWelterweight = "Super Welterweight"
    case welterweight = "Welterweight"
    case superLightweight = "Super Lightweight"
    case lightweight = "Lightweight"
    case featherweight = "Featherweight"
    case bantamweight = "Bantamweight"
}

struct Fighter: Identifiable, Sendable {
    let id: String
    let name: String
    let nickname: String
    let record: String
    let country: String
    let imageURL: String?
}

nonisolated enum FightTag: String, Sendable, CaseIterable {
    case war = "War"
    case robbery = "Robbery"
    case clinic = "Clinic"
    case snoozer = "Snoozer"
    case upset = "Upset"
}

nonisolated enum RoundTag: String, Sendable, CaseIterable {
    case knockdown = "Knockdown"
    case close = "Close"
    case dominant = "Dominant"
}

nonisolated enum PredictionMethod: String, Sendable, CaseIterable {
    case ko = "KO/TKO"
    case decision = "Decision"
    case split = "Split Decision"
    case draw = "Draw"
}

struct FightResult: Sendable {
    let method: String
    let scores: String?
    let winnerName: String?
}

struct Fight: Identifiable, Sendable {
    let id: String
    let fighterA: Fighter
    let fighterB: Fighter
    let weightClass: WeightClass
    let scheduledRounds: Int
    let status: FightStatus
    let currentRound: Int?
    let viewerCount: Int?
    let communityRating: Double
    let commentCount: Int
    let cardSection: CardSection
    let isTitleFight: Bool
    let startTime: Date?
    let result: FightResult?

    init(id: String, fighterA: Fighter, fighterB: Fighter, weightClass: WeightClass, scheduledRounds: Int, status: FightStatus, currentRound: Int? = nil, viewerCount: Int? = nil, communityRating: Double = 0, commentCount: Int = 0, cardSection: CardSection = .mainCard, isTitleFight: Bool = false, startTime: Date? = nil, result: FightResult? = nil) {
        self.id = id
        self.fighterA = fighterA
        self.fighterB = fighterB
        self.weightClass = weightClass
        self.scheduledRounds = scheduledRounds
        self.status = status
        self.currentRound = currentRound
        self.viewerCount = viewerCount
        self.communityRating = communityRating
        self.commentCount = commentCount
        self.cardSection = cardSection
        self.isTitleFight = isTitleFight
        self.startTime = startTime
        self.result = result
    }
}

struct FighterHighlight: Sendable {
    let fighter: Fighter
    let grade: Double
    let fightContext: String
}

struct Event: Identifiable, Sendable {
    let id: String
    let name: String
    let date: Date
    let venue: String
    let fights: [Fight]
    let isMainEvent: Bool
}

struct RoundScore: Identifiable, Sendable {
    let id: String
    let round: Int
    var fighterAScore: Int
    var fighterBScore: Int
    let communityAScore: Double
    let communityBScore: Double
}

struct UserRoundRating: Identifiable, Sendable {
    var id: Int { round }
    let round: Int
    var score: Double
    var tags: Set<RoundTag>
}

struct DiscussionComment: Identifiable, Sendable {
    let id: String
    let userName: String
    let text: String
    let timestamp: Date
    var thumbsUp: Int
    var thumbsDown: Int
    var hasThumbedUp: Bool
    var hasThumbedDown: Bool
    let isPrediction: Bool
}

struct FighterStats: Sendable {
    let power: Double
    let precision: Double
    let combinations: Double
    let defense: Double
    let ringGeneralship: Double
    let stamina: Double
}
