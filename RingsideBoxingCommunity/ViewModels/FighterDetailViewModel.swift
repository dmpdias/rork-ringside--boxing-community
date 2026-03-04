import SwiftUI

struct FighterFightRecord: Identifiable {
    let id: String
    let fight: Fight
    let opponentName: String
    let opponentImageURL: String?
    let opponentRecord: String
    let result: String
    let method: String
    let eventName: String
    let date: Date
    let isWin: Bool
    let isDraw: Bool
    let communityGrade: Double
}

@Observable
class FighterDetailViewModel {
    let fighter: Fighter
    var fightRecords: [FighterFightRecord] = []
    var averageGrade: Double = 0
    var wins: Int = 0
    var losses: Int = 0
    var draws: Int = 0
    var koRate: String = ""

    init(fighter: Fighter) {
        self.fighter = fighter
        buildFightHistory()
        parseRecord()
    }

    private func buildFightHistory() {
        let allEvents = RealBoxingData.allEvents
        var records: [FighterFightRecord] = []

        for event in allEvents {
            for fight in event.fights {
                let isA = fight.fighterA.id == fighter.id
                let isB = fight.fighterB.id == fighter.id
                guard isA || isB else { continue }

                let opponent = isA ? fight.fighterB : fight.fighterA
                let winnerName = fight.result?.winnerName

                let isWin: Bool
                let isDraw: Bool
                let resultLabel: String

                if fight.status == .completed {
                    if let winner = winnerName {
                        isWin = winner == fighter.name
                        isDraw = false
                        resultLabel = isWin ? "W" : "L"
                    } else {
                        isWin = false
                        isDraw = true
                        resultLabel = "D"
                    }
                } else {
                    isWin = false
                    isDraw = false
                    resultLabel = fight.status == .live ? "LIVE" : "UPCOMING"
                }

                records.append(FighterFightRecord(
                    id: fight.id,
                    fight: fight,
                    opponentName: opponent.name,
                    opponentImageURL: opponent.imageURL,
                    opponentRecord: opponent.record,
                    result: resultLabel,
                    method: fight.result?.method ?? "",
                    eventName: event.name,
                    date: event.date,
                    isWin: isWin,
                    isDraw: isDraw,
                    communityGrade: fight.communityRating
                ))
            }
        }

        fightRecords = records.sorted { $0.date > $1.date }

        let completedRecords = records.filter { $0.result == "W" || $0.result == "L" || $0.result == "D" }
        if !completedRecords.isEmpty {
            averageGrade = completedRecords.reduce(0.0) { $0 + $1.communityGrade } / Double(completedRecords.count)
        }
    }

    private func parseRecord() {
        let parts = fighter.record.split(separator: "-")
        if parts.count >= 3 {
            wins = Int(parts[0]) ?? 0
            losses = Int(parts[1]) ?? 0
            draws = Int(parts[2]) ?? 0
        }

        let total = wins + losses + draws
        guard total > 0 else {
            koRate = "N/A"
            return
        }

        let completedKOs = fightRecords.filter { $0.isWin && ($0.method.contains("KO") || $0.method.contains("TKO")) }.count
        let estimatedKOs = max(completedKOs, Int(Double(wins) * 0.6))
        let rate = Int((Double(estimatedKOs) / Double(wins)) * 100)
        koRate = "\(min(rate, 100))%"
    }
}
