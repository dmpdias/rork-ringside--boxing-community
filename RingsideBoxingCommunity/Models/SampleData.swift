import Foundation

struct SampleData {
    static let fighterCrawford = Fighter(id: "f1", name: "Terence Crawford", nickname: "Bud", record: "40-0-0", country: "🇺🇸", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Terence_Crawford_2023.jpg/440px-Terence_Crawford_2023.jpg")
    static let fighterSpence = Fighter(id: "f2", name: "Errol Spence Jr.", nickname: "The Truth", record: "28-1-0", country: "🇺🇸", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Errol_Spence_Jr.png/440px-Errol_Spence_Jr.png")
    static let fighterCanelo = Fighter(id: "f3", name: "Canelo Alvarez", nickname: "Canelo", record: "61-2-2", country: "🇲🇽", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Canelo_%C3%81lvarez_2020_%28cropped%29.jpg/440px-Canelo_%C3%81lvarez_2020_%28cropped%29.jpg")
    static let fighterBenavidez = Fighter(id: "f4", name: "David Benavidez", nickname: "El Monstruo", record: "29-0-0", country: "🇺🇸", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/David_Benavidez_2024.jpg/440px-David_Benavidez_2024.jpg")
    static let fighterInoue = Fighter(id: "f5", name: "Naoya Inoue", nickname: "Monster", record: "27-0-0", country: "🇯🇵", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Naoya_Inoue_2023_%28cropped%29.jpg/440px-Naoya_Inoue_2023_%28cropped%29.jpg")
    static let fighterNery = Fighter(id: "f6", name: "Luis Nery", nickname: "Pantera", record: "35-1-0", country: "🇲🇽", imageURL: nil)
    static let fighterBeterbiev = Fighter(id: "f7", name: "Artur Beterbiev", nickname: "Lion", record: "20-0-0", country: "🇷🇺", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Artur_Beterbiev_2023.jpg/440px-Artur_Beterbiev_2023.jpg")
    static let fighterBivol = Fighter(id: "f8", name: "Dmitry Bivol", nickname: "The Soldier", record: "23-1-0", country: "🇰🇬", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Dmitry_Bivol_2022.jpg/440px-Dmitry_Bivol_2022.jpg")
    static let fighterTank = Fighter(id: "f9", name: "Gervonta Davis", nickname: "Tank", record: "30-0-0", country: "🇺🇸", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Gervonta_Davis_2023.jpg/440px-Gervonta_Davis_2023.jpg")
    static let fighterLoma = Fighter(id: "f10", name: "Vasiliy Lomachenko", nickname: "Hi-Tech", record: "18-3-0", country: "🇺🇦", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Vasyl_Lomachenko_2023.jpg/440px-Vasyl_Lomachenko_2023.jpg")
    static let fighterFury = Fighter(id: "f11", name: "Tyson Fury", nickname: "The Gypsy King", record: "34-2-1", country: "🇬🇧", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Tyson_Fury_at_WBC_Convention_2018.jpg/440px-Tyson_Fury_at_WBC_Convention_2018.jpg")
    static let fighterUsyk = Fighter(id: "f12", name: "Oleksandr Usyk", nickname: "The Cat", record: "22-0-0", country: "🇺🇦", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Oleksandr_Usyk_2024.jpg/440px-Oleksandr_Usyk_2024.jpg")

    static let liveFight = Fight(
        id: "fight1",
        fighterA: fighterCanelo,
        fighterB: fighterBenavidez,
        weightClass: .superMiddleweight,
        scheduledRounds: 12,
        status: .live,
        currentRound: 7,
        viewerCount: 24_832,
        communityRating: 4.8,
        commentCount: 3_241,
        cardSection: .mainCard,
        isTitleFight: true
    )

    static let fighterHaney = Fighter(id: "f13", name: "Devin Haney", nickname: "The Dream", record: "31-0-0", country: "🇺🇸", imageURL: nil)
    static let fighterShakur = Fighter(id: "f14", name: "Shakur Stevenson", nickname: "Fearless", record: "21-0-0", country: "🇺🇸", imageURL: nil)
    static let fighterMunguia = Fighter(id: "f15", name: "Jaime Munguia", nickname: "El Rayo", record: "43-1-0", country: "🇲🇽", imageURL: nil)
    static let fighterCharlo = Fighter(id: "f16", name: "Jermell Charlo", nickname: "Iron Man", record: "35-2-1", country: "🇺🇸", imageURL: nil)

    private static let cal = Calendar.current
    private static func day(_ offset: Int) -> Date {
        cal.date(byAdding: .day, value: offset, to: cal.startOfDay(for: Date()))!
    }

    static let events: [Event] = [
        Event(
            id: "e_m7",
            name: "WARRIORS CLASH",
            date: day(-7),
            venue: "O2 Arena, London",
            fights: [
                Fight(id: "fight_m7a", fighterA: fighterFury, fighterB: fighterBeterbiev, weightClass: .heavyweight, scheduledRounds: 12, status: .completed, currentRound: nil, viewerCount: nil, communityRating: 4.5, commentCount: 3_450, cardSection: .mainCard, isTitleFight: true, result: FightResult(method: "UD", scores: "116–112, 115–113, 115–113", winnerName: "Tyson Fury")),
                Fight(id: "fight_m7b", fighterA: fighterMunguia, fighterB: fighterNery, weightClass: .superMiddleweight, scheduledRounds: 10, status: .completed, currentRound: nil, viewerCount: nil, communityRating: 3.6, commentCount: 890, cardSection: .undercard, result: FightResult(method: "TKO R6", scores: nil, winnerName: "Jaime Munguia"))
            ],
            isMainEvent: false
        ),
        Event(
            id: "e_m5",
            name: "FRIDAY NIGHT FIGHTS",
            date: day(-5),
            venue: "Mohegan Sun Arena, CT",
            fights: [
                Fight(id: "fight_m5a", fighterA: fighterTank, fighterB: fighterHaney, weightClass: .lightweight, scheduledRounds: 12, status: .completed, currentRound: nil, viewerCount: nil, communityRating: 4.8, commentCount: 6_200, cardSection: .mainCard, isTitleFight: true, result: FightResult(method: "KO R8", scores: nil, winnerName: "Gervonta Davis")),
                Fight(id: "fight_m5b", fighterA: fighterShakur, fighterB: fighterLoma, weightClass: .superLightweight, scheduledRounds: 12, status: .completed, currentRound: nil, viewerCount: nil, communityRating: 4.2, commentCount: 1_870, cardSection: .undercard, result: FightResult(method: "SD", scores: "115–113, 114–114, 116–112", winnerName: "Shakur Stevenson"))
            ],
            isMainEvent: true
        ),
        Event(
            id: "e_m2",
            name: "KNOCKOUT KINGS",
            date: day(-2),
            venue: "Barclays Center, Brooklyn",
            fights: [
                Fight(id: "fight_m2a", fighterA: fighterHaney, fighterB: fighterShakur, weightClass: .superLightweight, scheduledRounds: 12, status: .completed, currentRound: nil, viewerCount: nil, communityRating: 4.4, commentCount: 2_780, cardSection: .mainCard, result: FightResult(method: "UD", scores: "117–111, 116–112, 116–112", winnerName: "Devin Haney")),
                Fight(id: "fight_m2b", fighterA: fighterMunguia, fighterB: fighterCharlo, weightClass: .superMiddleweight, scheduledRounds: 12, status: .completed, currentRound: nil, viewerCount: nil, communityRating: 3.9, commentCount: 1_120, cardSection: .undercard, result: FightResult(method: "MD", scores: "115–113, 115–113, 114–114", winnerName: "Jaime Munguia"))
            ],
            isMainEvent: false
        ),
        Event(
            id: "e_m1",
            name: "BATTLE OF CHAMPIONS",
            date: day(-1),
            venue: "Crypto.com Arena, Los Angeles",
            fights: [
                Fight(id: "fight_m1a", fighterA: fighterCrawford, fighterB: fighterSpence, weightClass: .welterweight, scheduledRounds: 12, status: .completed, currentRound: nil, viewerCount: nil, communityRating: 4.9, commentCount: 5_102, cardSection: .mainCard, isTitleFight: true, result: FightResult(method: "TKO R9", scores: nil, winnerName: "Terence Crawford")),
                Fight(id: "fight_m1b", fighterA: fighterInoue, fighterB: fighterNery, weightClass: .bantamweight, scheduledRounds: 12, status: .completed, currentRound: nil, viewerCount: nil, communityRating: 4.3, commentCount: 987, cardSection: .undercard, result: FightResult(method: "KO R6", scores: nil, winnerName: "Naoya Inoue"))
            ],
            isMainEvent: false
        ),
        Event(
            id: "e1",
            name: "SHOWDOWN IN VEGAS",
            date: day(0),
            venue: "T-Mobile Arena, Las Vegas",
            fights: [
                liveFight,
                Fight(id: "fight2", fighterA: fighterTank, fighterB: fighterLoma, weightClass: .lightweight, scheduledRounds: 12, status: .live, currentRound: 3, viewerCount: 18_420, communityRating: 4.5, commentCount: 1_892, cardSection: .mainCard),
                Fight(id: "fight2b", fighterA: fighterHaney, fighterB: fighterShakur, weightClass: .superLightweight, scheduledRounds: 10, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.1, commentCount: 540, cardSection: .undercard, startTime: Date().addingTimeInterval(5040)),
                Fight(id: "fight2c", fighterA: fighterMunguia, fighterB: fighterCharlo, weightClass: .superMiddleweight, scheduledRounds: 10, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 3.8, commentCount: 320, cardSection: .prelims, startTime: Date().addingTimeInterval(9000))
            ],
            isMainEvent: true
        ),
        Event(
            id: "e_p1",
            name: "RISING STARS",
            date: day(1),
            venue: "The Forum, Inglewood",
            fights: [
                Fight(id: "fight_p1a", fighterA: fighterBeterbiev, fighterB: fighterBivol, weightClass: .lightHeavyweight, scheduledRounds: 12, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.7, commentCount: 2_310, cardSection: .mainCard, isTitleFight: true, startTime: day(1).addingTimeInterval(72000))
            ],
            isMainEvent: false
        ),
        Event(
            id: "e2",
            name: "CHAMPIONS COLLIDE",
            date: day(3),
            venue: "Madison Square Garden, New York",
            fights: [
                Fight(id: "fight4", fighterA: fighterBeterbiev, fighterB: fighterBivol, weightClass: .lightHeavyweight, scheduledRounds: 12, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.7, commentCount: 2_310, cardSection: .mainCard, isTitleFight: true, startTime: day(3).addingTimeInterval(72000)),
                Fight(id: "fight5", fighterA: fighterInoue, fighterB: fighterNery, weightClass: .bantamweight, scheduledRounds: 12, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.3, commentCount: 987, cardSection: .undercard, startTime: day(3).addingTimeInterval(64800))
            ],
            isMainEvent: false
        ),
        Event(
            id: "e_p5",
            name: "THUNDER IN THE EAST",
            date: day(5),
            venue: "Saitama Super Arena, Tokyo",
            fights: [
                Fight(id: "fight_p5a", fighterA: fighterInoue, fighterB: fighterTank, weightClass: .bantamweight, scheduledRounds: 12, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.9, commentCount: 7_620, cardSection: .mainCard),
                Fight(id: "fight_p5b", fighterA: fighterLoma, fighterB: fighterShakur, weightClass: .lightweight, scheduledRounds: 10, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.4, commentCount: 2_100, cardSection: .undercard)
            ],
            isMainEvent: true
        ),
        Event(
            id: "e3",
            name: "FURY VS USYK III",
            date: day(7),
            venue: "Kingdom Arena, Riyadh",
            fights: [
                Fight(id: "fight6", fighterA: fighterFury, fighterB: fighterUsyk, weightClass: .heavyweight, scheduledRounds: 12, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.6, commentCount: 8_430, cardSection: .mainCard, isTitleFight: true, startTime: day(7).addingTimeInterval(72000))
            ],
            isMainEvent: false
        ),
        Event(
            id: "e_p9",
            name: "BATTLE ROYALE",
            date: day(9),
            venue: "AT&T Stadium, Dallas",
            fights: [
                Fight(id: "fight_p9a", fighterA: fighterCrawford, fighterB: fighterCanelo, weightClass: .superMiddleweight, scheduledRounds: 12, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 5.0, commentCount: 12_340, cardSection: .mainCard, isTitleFight: true, startTime: day(9).addingTimeInterval(72000)),
                Fight(id: "fight_p9b", fighterA: fighterSpence, fighterB: fighterCharlo, weightClass: .superWelterweight, scheduledRounds: 12, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.1, commentCount: 1_560, cardSection: .undercard)
            ],
            isMainEvent: true
        ),
        Event(
            id: "e_p12",
            name: "LEGENDS NIGHT",
            date: day(12),
            venue: "MGM Grand, Las Vegas",
            fights: [
                Fight(id: "fight_p12a", fighterA: fighterBenavidez, fighterB: fighterBivol, weightClass: .lightHeavyweight, scheduledRounds: 12, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.5, commentCount: 3_890, cardSection: .mainCard),
                Fight(id: "fight_p12b", fighterA: fighterHaney, fighterB: fighterTank, weightClass: .lightweight, scheduledRounds: 12, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 4.8, commentCount: 5_670, cardSection: .mainCard),
                Fight(id: "fight_p12c", fighterA: fighterMunguia, fighterB: fighterNery, weightClass: .middleweight, scheduledRounds: 10, status: .upcoming, currentRound: nil, viewerCount: nil, communityRating: 3.7, commentCount: 780, cardSection: .prelims)
            ],
            isMainEvent: false
        )
    ]

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
        ChatMessage(id: "c1", userName: "BoxingFanatic99", text: "Canelo's counter right hand is LETHAL tonight 🔥", timestamp: Date().addingTimeInterval(-120), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c2", userName: "RingSideKing", text: "Benavidez needs to work the body more", timestamp: Date().addingTimeInterval(-95), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c3", userName: "You", text: "That uppercut in round 5 was insane!", timestamp: Date().addingTimeInterval(-80), isCurrentUser: true, reaction: nil),
        ChatMessage(id: "c4", userName: "FightNightMike", text: "I have it 4-3 Canelo so far. Close fight!", timestamp: Date().addingTimeInterval(-60), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c5", userName: "UndercardHunter", text: "Benavidez volume is picking up in the later rounds", timestamp: Date().addingTimeInterval(-45), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c6", userName: "BoxingFanatic99", text: "WHAT A ROUND! 👊👊👊", timestamp: Date().addingTimeInterval(-30), isCurrentUser: false, reaction: "🔥"),
        ChatMessage(id: "c7", userName: "JudgeScorecards", text: "Round 7 clearly Canelo. Beautiful combinations.", timestamp: Date().addingTimeInterval(-15), isCurrentUser: false, reaction: nil),
        ChatMessage(id: "c8", userName: "You", text: "This is fight of the year material", timestamp: Date().addingTimeInterval(-5), isCurrentUser: true, reaction: nil),
    ]

    static let samplePosts: [Post] = [
        Post(id: "p1", userName: "Mike Rodriguez", userHandle: "@mikeboxing", avatarEmoji: "🥊", badges: ["Matchmaker", "Analyst"], fightContext: "Canelo vs Benavidez", text: "Called this fight 6 months ago. Canelo's movement is the difference — Benavidez has power but can't find him clean. Classic matador vs bull matchup.", likes: 342, comments: 47, timestamp: Date().addingTimeInterval(-300), isLiked: false),
        Post(id: "p2", userName: "Sarah Chen", userHandle: "@sarahfights", avatarEmoji: "🏆", badges: ["Scout"], fightContext: nil, text: "Keep an eye on the Tank vs Loma co-main. Loma at 36 still has the footwork to make this interesting. Predicting a chess match for the first 6 rounds.", likes: 189, comments: 23, timestamp: Date().addingTimeInterval(-1800), isLiked: true),
        Post(id: "p3", userName: "James Wright", userHandle: "@wrightcross", avatarEmoji: "💪", badges: ["Hunter"], fightContext: "Beterbiev vs Bivol", text: "Beterbiev is the most dangerous man in boxing. 20-0 with 20 KOs. But Bivol's technique might be the code that cracks him. MSG is going to be electric.", likes: 521, comments: 89, timestamp: Date().addingTimeInterval(-3600), isLiked: false),
        Post(id: "p4", userName: "Elena Martinez", userHandle: "@elenarm", avatarEmoji: "⭐", badges: ["Analyst", "Scout"], fightContext: "Fury vs Usyk III", text: "Trilogy fights in boxing are special. Fury needs to come in lighter this time. Usyk's conditioning was the story in fight 2. Riyadh is going to be incredible.", likes: 278, comments: 34, timestamp: Date().addingTimeInterval(-7200), isLiked: false),
        Post(id: "p5", userName: "Dev Thompson", userHandle: "@devknockout", avatarEmoji: "🔥", badges: ["Matchmaker"], fightContext: nil, text: "My dream matchup: Crawford vs Spence at 154. Both coming off long layoffs but the skill gap would be fascinating to see at a higher weight. Who says no?", likes: 893, comments: 156, timestamp: Date().addingTimeInterval(-14400), isLiked: true),
    ]

    static let fighterHighlights: [Int: FighterHighlight] = [
        -2: FighterHighlight(fighter: fighterHaney, grade: 8.7, fightContext: "vs Shakur Stevenson"),
        -1: FighterHighlight(fighter: fighterCrawford, grade: 9.8, fightContext: "vs Errol Spence Jr."),
        0: FighterHighlight(fighter: fighterCanelo, grade: 9.4, fightContext: "vs David Benavidez"),
        1: FighterHighlight(fighter: fighterBeterbiev, grade: 9.1, fightContext: "vs Dmitry Bivol"),
        3: FighterHighlight(fighter: fighterBeterbiev, grade: 8.9, fightContext: "vs Dmitry Bivol"),
        7: FighterHighlight(fighter: fighterUsyk, grade: 9.6, fightContext: "vs Tyson Fury"),
    ]

    static func highlightForDate(_ date: Date) -> FighterHighlight? {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let target = cal.startOfDay(for: date)
        let dayOffset = cal.dateComponents([.day], from: today, to: target).day ?? 0
        return fighterHighlights[dayOffset]
    }

    static func interactionsForFights() -> [String: FightInteraction] {
        var interactions: [String: FightInteraction] = [:]
        let allFights = events.flatMap(\.fights)
        for fight in allFights {
            let hasRating = ["fight1", "fight2", "fight_m1a", "fight_m2a", "fight_m5a", "fight_m7a"].contains(fight.id)
            let ratings: [String: Double] = ["fight1": 9.2, "fight2": 8.5, "fight_m1a": 9.8, "fight_m2a": 7.4, "fight_m5a": 9.0, "fight_m7a": 6.8]
            let comments: [String: String] = [
                "fight1": "Canelo's counters are on another level tonight",
                "fight2": "Tank's power is scary but Loma's footwork is elite",
                "fight_m1a": "Fight of the decade. Crawford is undeniable.",
                "fight_m2a": "Haney's jab controlled the whole fight",
                "fight_m5a": "Tank showed why he's the most exciting fighter alive",
                "fight_m7a": "Fury looked sluggish, not his best performance"
            ]
            let sampleComments: [FightComment] = [
                FightComment(id: "fc_\(fight.id)_1", userName: "BoxingFanatic99", avatarEmoji: "🥊", text: "Great matchup, both fighters brought it", timestamp: Date().addingTimeInterval(-3600)),
                FightComment(id: "fc_\(fight.id)_2", userName: "RingSideKing", avatarEmoji: "👑", text: "The judges got this one right", timestamp: Date().addingTimeInterval(-1800)),
                FightComment(id: "fc_\(fight.id)_3", userName: "FightNightMike", avatarEmoji: "🔥", text: "Can't wait for the rematch", timestamp: Date().addingTimeInterval(-900)),
            ]
            interactions[fight.id] = FightInteraction(
                id: "int_\(fight.id)",
                fightId: fight.id,
                userRating: hasRating ? ratings[fight.id] : nil,
                userComment: hasRating ? comments[fight.id] : nil,
                thumbsUp: Int.random(in: 12...340),
                thumbsDown: Int.random(in: 2...45),
                hasThumbedUp: false,
                hasThumbedDown: false,
                communityComments: sampleComments
            )
        }
        return interactions
    }

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
            ActivityItem(id: "a1", type: .scorecard, title: "Scored Canelo vs Benavidez", subtitle: "Round 7 — 67-66 Canelo", timestamp: Date().addingTimeInterval(-600)),
            ActivityItem(id: "a2", type: .post, title: "Posted in Community", subtitle: "\"Crawford is P4P #1 and it's not close\"", timestamp: Date().addingTimeInterval(-3600)),
            ActivityItem(id: "a3", type: .badge, title: "Earned Analyst Badge", subtitle: "Scored 50+ fights accurately", timestamp: Date().addingTimeInterval(-86400)),
            ActivityItem(id: "a4", type: .scorecard, title: "Scored Beterbiev vs Bivol", subtitle: "Prediction: Beterbiev KO R9", timestamp: Date().addingTimeInterval(-172800)),
        ]
    )
}
