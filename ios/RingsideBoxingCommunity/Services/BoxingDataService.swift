import Foundation

nonisolated struct SportsDBEvent: Codable, Sendable {
    let idEvent: String?
    let strEvent: String?
    let strSport: String?
    let strLeague: String?
    let strHomeTeam: String?
    let strAwayTeam: String?
    let intHomeScore: String?
    let intAwayScore: String?
    let strVenue: String?
    let strCountry: String?
    let dateEvent: String?
    let strTime: String?
    let strStatus: String?
    let strResult: String?
    let strThumb: String?
    let strPoster: String?
}

nonisolated struct SportsDBResponse: Codable, Sendable {
    let events: [SportsDBEvent]?
}

@Observable
class BoxingDataService {
    var events: [Event] = []
    var isLoading: Bool = false
    var lastRefresh: Date?
    private var refreshTask: Task<Void, Never>?

    init() {
        loadLiveData()
    }

    func refresh() {
        loadLiveData()
    }

    private func loadLiveData() {
        isLoading = true
        events = RealBoxingData.allEvents
        lastRefresh = Date()
        isLoading = false

        refreshTask?.cancel()
        refreshTask = Task {
            await fetchRemoteEvents()
        }
    }

    private func fetchRemoteEvents() async {
        let baseURL = "https://www.thesportsdb.com/api/v1/json/3"

        if let upcoming = await fetchEvents(from: "\(baseURL)/eventsnextleague.php?id=4445") {
            let converted = convertRemoteEvents(upcoming, status: .upcoming)
            if !converted.isEmpty {
                mergeRemoteEvents(converted)
            }
        }

        if let past = await fetchEvents(from: "\(baseURL)/eventspastleague.php?id=4445") {
            let converted = convertRemoteEvents(past, status: .completed)
            if !converted.isEmpty {
                mergeRemoteEvents(converted)
            }
        }
    }

    private func fetchEvents(from urlString: String) async -> [SportsDBEvent]? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(SportsDBResponse.self, from: data)
            return response.events?.filter {
                $0.strSport == "Fighting" || $0.strSport == "Boxing" || $0.strSport == nil
            }
        } catch {
            return nil
        }
    }

    private func convertRemoteEvents(_ remoteEvents: [SportsDBEvent], status: FightStatus) -> [Event] {
        let grouped = Dictionary(grouping: remoteEvents) { event in
            "\(event.dateEvent ?? "")_\(event.strVenue ?? "")"
        }

        return grouped.compactMap { _, groupedEvents -> Event? in
            guard let first = groupedEvents.first,
                  let dateStr = first.dateEvent else { return nil }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            guard let date = formatter.date(from: dateStr) else { return nil }

            let fights = groupedEvents.compactMap { event -> Fight? in
                guard let home = event.strHomeTeam, let away = event.strAwayTeam else { return nil }

                let fighterA = Fighter(id: "api_\(home.hashValue)", name: home, nickname: "", record: "", country: "", imageURL: nil)
                let fighterB = Fighter(id: "api_\(away.hashValue)", name: away, nickname: "", record: "", country: "", imageURL: nil)

                var result: FightResult?
                if status == .completed, let resultStr = event.strResult, !resultStr.isEmpty {
                    result = FightResult(method: resultStr, scores: nil, winnerName: home)
                }

                return Fight(
                    id: event.idEvent ?? UUID().uuidString,
                    fighterA: fighterA,
                    fighterB: fighterB,
                    weightClass: .middleweight,
                    scheduledRounds: 12,
                    status: status,
                    communityRating: Double.random(in: 3.5...4.8),
                    commentCount: Int.random(in: 50...500),
                    cardSection: .mainCard,
                    startTime: date,
                    result: result
                )
            }

            guard !fights.isEmpty else { return nil }

            return Event(
                id: "api_\(first.idEvent ?? UUID().uuidString)",
                name: first.strEvent?.uppercased() ?? "BOXING EVENT",
                date: date,
                venue: [first.strVenue, first.strCountry].compactMap { $0 }.joined(separator: ", "),
                fights: fights,
                isMainEvent: false
            )
        }
    }

    private func mergeRemoteEvents(_ remote: [Event]) {
        for remoteEvent in remote {
            if !events.contains(where: { $0.id == remoteEvent.id }) {
                events.append(remoteEvent)
            }
        }
        events.sort { $0.date < $1.date }
    }
}
