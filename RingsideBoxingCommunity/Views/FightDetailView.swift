import SwiftUI

nonisolated enum FightDetailTab: String, CaseIterable, Sendable {
    case scorecard = "Scorecard"
    case stats = "Stats"
    case chat = "Live Chat"
}

struct FightDetailView: View {
    let fight: Fight
    @State private var selectedTab: FightDetailTab = .scorecard
    @State private var roundScores: [RoundScore] = SampleData.sampleRoundScores
    @State private var chatMessages: [ChatMessage] = SampleData.sampleChatMessages
    @State private var messageText: String = ""
    @State private var overallRating: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    heroHeader
                    fighterInfoCard
                    actionButtons
                        .padding(.top, 12)
                    tabPicker
                        .padding(.top, 16)
                    tabContent
                        .padding(.top, 12)
                }
                .padding(.bottom, selectedTab == .chat ? 80 : 32)
            }
            .scrollIndicators(.hidden)

            if selectedTab == .chat {
                chatInputBar
            }
        }
        .background(
            MeshBackgroundView()
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(fight.weightClass.rawValue.uppercased())
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.5))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button { } label: {
                        Label("Share Fight", systemImage: "square.and.arrow.up")
                    }
                    Button { } label: {
                        Label("Report", systemImage: "flag")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
    }

    private var heroHeader: some View {
        VStack(spacing: 0) {
            Text(eventNameForFight.uppercased())
                .font(.system(size: 22, weight: .heavy, design: .default).width(.compressed))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 4)

            Text(eventSubtitle)
                .font(.system(.caption, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))
                .padding(.top, 2)

            HStack(alignment: .bottom, spacing: 0) {
                fighterPhoto(fighter: fight.fighterA, alignment: .leading)

                VStack(spacing: 6) {
                    if fight.status == .live {
                        HStack(spacing: 5) {
                            LiveDot()
                            Text("RD \(fight.currentRound ?? 1)/\(fight.scheduledRounds)")
                                .font(.system(.caption2, weight: .bold).width(.compressed))
                                .foregroundStyle(RingsideTheme.liveRed)
                        }
                    }

                    Text("VS")
                        .font(.system(size: 36, weight: .black, design: .default).width(.compressed))
                        .foregroundStyle(RingsideTheme.gold)

                    statusLabel
                }
                .frame(width: 80)
                .padding(.bottom, 40)

                fighterPhoto(fighter: fight.fighterB, alignment: .trailing)
            }
            .padding(.top, 8)
        }
    }

    private func fighterPhoto(fighter: Fighter, alignment: HorizontalAlignment) -> some View {
        VStack(spacing: 0) {
            if let urlString = fighter.imageURL, let url = URL(string: urlString) {
                Color.clear
                    .frame(height: 220)
                    .overlay {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                fighterPlaceholder
                            case .empty:
                                ProgressView()
                                    .tint(.white.opacity(0.3))
                            @unknown default:
                                fighterPlaceholder
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    .clipShape(.rect(cornerRadius: 16))
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .clear, Color(red: 0.04, green: 0.04, blue: 0.07).opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(.rect(cornerRadius: 16))
                    )
                    .overlay(alignment: .bottom) {
                        VStack(spacing: 2) {
                            Text(fighter.country)
                                .font(.title3)
                            Text(fighter.name.components(separatedBy: " ").last ?? "")
                                .font(.system(.subheadline, weight: .heavy).width(.compressed))
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, 8)
                    }
            } else {
                VStack(spacing: 0) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.06), Color.white.opacity(0.02)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 220)

                        VStack(spacing: 8) {
                            Image(systemName: "figure.boxing")
                                .font(.system(size: 64))
                                .foregroundStyle(.white.opacity(0.15))
                            Text(fighter.country)
                                .font(.title3)
                            Text(fighter.name.components(separatedBy: " ").last ?? "")
                                .font(.system(.subheadline, weight: .heavy).width(.compressed))
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var fighterPlaceholder: some View {
        ZStack {
            Color.white.opacity(0.04)
            Image(systemName: "figure.boxing")
                .font(.system(size: 54))
                .foregroundStyle(.white.opacity(0.12))
        }
    }

    @ViewBuilder
    private var statusLabel: some View {
        switch fight.status {
        case .live:
            Text("LIVE")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(RingsideTheme.liveRed)
        case .upcoming:
            Text(fight.date?.formatted(.dateTime.month(.abbreviated).day()) ?? "TBD")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(.white.opacity(0.4))
        case .completed:
            Text("FINAL")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(RingsideTheme.gold)
        }
    }

    private var fighterInfoCard: some View {
        HStack {
            VStack(spacing: 2) {
                Text(fight.fighterA.name)
                    .font(.system(.subheadline, weight: .bold).width(.compressed))
                    .foregroundStyle(.white)
                Text(fight.fighterA.record)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.4))
                if !fight.fighterA.nickname.isEmpty {
                    Text("\"\(fight.fighterA.nickname)\"")
                        .font(.system(.caption2, weight: .medium).italic())
                        .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 2) {
                Text(fight.weightClass.rawValue.uppercased())
                    .font(.system(.caption2, weight: .bold).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                Text("\(fight.scheduledRounds) ROUNDS")
                    .font(.system(.caption2, weight: .semibold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.3))
            }

            VStack(spacing: 2) {
                Text(fight.fighterB.name)
                    .font(.system(.subheadline, weight: .bold).width(.compressed))
                    .foregroundStyle(.white)
                Text(fight.fighterB.record)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.4))
                if !fight.fighterB.nickname.isEmpty {
                    Text("\"\(fight.fighterB.nickname)\"")
                        .font(.system(.caption2, weight: .medium).italic())
                        .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.white.opacity(0.12), Color.white.opacity(0.04)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 0.5
                )
        )
        .padding(.horizontal, 16)
    }

    private var actionButtons: some View {
        HStack(spacing: 10) {
            Button { } label: {
                Image(systemName: "bookmark")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(width: 44, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
                    )
            }

            Button { } label: {
                HStack(spacing: 6) {
                    Image(systemName: "play.fill")
                        .font(.caption)
                    Text("HIGHLIGHTS")
                        .font(.system(.caption, weight: .bold).width(.compressed))
                }
                .foregroundStyle(.white.opacity(0.7))
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
                )
            }

            Button { } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chart.bar.fill")
                        .font(.caption)
                    Text("PREDICT")
                        .font(.system(.caption, weight: .bold).width(.compressed))
                }
                .foregroundStyle(RingsideTheme.gold)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(RingsideTheme.gold.opacity(0.12))
                .clipShape(.rect(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(RingsideTheme.gold.opacity(0.25), lineWidth: 0.5)
                )
            }

            Button { } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(width: 44, height: 40)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
                    )
            }
        }
        .padding(.horizontal, 16)
    }

    private var tabPicker: some View {
        HStack(spacing: 4) {
            ForEach(FightDetailTab.allCases, id: \.rawValue) { tab in
                Button {
                    withAnimation(.snappy) { selectedTab = tab }
                } label: {
                    Text(tab.rawValue)
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(selectedTab == tab ? .white : .white.opacity(0.4))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Capsule(style: .continuous)
                                .fill(selectedTab == tab ? Color.white.opacity(0.1) : Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            Capsule(style: .continuous)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
        )
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .scorecard:
            scorecardContent
        case .stats:
            statsContent
        case .chat:
            chatContent
        }
    }

    private var scorecardContent: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                HStack {
                    Text(fight.fighterA.name.components(separatedBy: " ").last ?? "")
                        .font(.system(.caption, weight: .bold).width(.compressed))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("RD")
                        .font(.system(.caption2, weight: .bold))
                        .foregroundStyle(.white.opacity(0.4))
                        .frame(width: 30)
                    Text(fight.fighterB.name.components(separatedBy: " ").last ?? "")
                        .font(.system(.caption, weight: .bold).width(.compressed))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal)

                ForEach(roundScores) { score in
                    RoundScoreRow(score: score, fighterAName: fight.fighterA.name, fighterBName: fight.fighterB.name)
                }
            }
            .padding(16)
            .glassCard()

            VStack(spacing: 12) {
                Text("RATE THIS FIGHT")
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.4))

                HStack(spacing: 8) {
                    ForEach(1...5, id: \.self) { star in
                        Button {
                            withAnimation(.bouncy) { overallRating = star }
                        } label: {
                            Image(systemName: star <= overallRating ? "star.fill" : "star")
                                .font(.title2)
                                .foregroundStyle(star <= overallRating ? RingsideTheme.gold : Color.white.opacity(0.15))
                        }
                        .sensoryFeedback(.impact(weight: .light), trigger: overallRating)
                    }
                }

                if overallRating > 0 {
                    Text("You rated this fight \(overallRating)/5")
                        .font(.caption)
                        .foregroundStyle(RingsideTheme.gold.opacity(0.7))
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(16)
            .glassGoldCard()
        }
        .padding(.horizontal)
    }

    private var statsContent: some View {
        VStack(spacing: 16) {
            Text("FIGHTER COMPARISON")
                .font(.system(.caption, weight: .bold).width(.compressed))
                .foregroundStyle(.white.opacity(0.4))

            let statPairs: [(String, Double, Double)] = [
                ("Power", SampleData.caneloStats.power, SampleData.benavidezStats.power),
                ("Precision", SampleData.caneloStats.precision, SampleData.benavidezStats.precision),
                ("Combinations", SampleData.caneloStats.combinations, SampleData.benavidezStats.combinations),
                ("Defense", SampleData.caneloStats.defense, SampleData.benavidezStats.defense),
                ("Ring IQ", SampleData.caneloStats.ringGeneralship, SampleData.benavidezStats.ringGeneralship),
                ("Stamina", SampleData.caneloStats.stamina, SampleData.benavidezStats.stamina),
            ]

            VStack(spacing: 14) {
                ForEach(statPairs, id: \.0) { label, valueA, valueB in
                    StatComparisonRow(
                        label: label,
                        valueA: valueA,
                        valueB: valueB,
                        nameA: fight.fighterA.name.components(separatedBy: " ").last ?? "",
                        nameB: fight.fighterB.name.components(separatedBy: " ").last ?? ""
                    )
                }
            }
            .padding(16)
            .glassCard()
        }
        .padding(.horizontal)
    }

    private var chatContent: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 6) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                    Text("\(fight.viewerCount ?? 0, format: .number) fans watching")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }
                Spacer()
                quickReactions
            }
            .padding(.horizontal)

            LazyVStack(spacing: 8) {
                ForEach(chatMessages) { message in
                    ChatBubble(message: message)
                }
            }
            .padding(.horizontal)
        }
    }

    private var quickReactions: some View {
        HStack(spacing: 8) {
            ForEach(["🔥", "👊", "😮", "👏"], id: \.self) { emoji in
                Button {
                    sendReaction(emoji)
                } label: {
                    Text(emoji)
                        .font(.body)
                        .frame(width: 36, height: 36)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle().strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
                        )
                }
                .sensoryFeedback(.impact(weight: .medium), trigger: chatMessages.count)
            }
        }
    }

    private var chatInputBar: some View {
        HStack(spacing: 12) {
            TextField("Send a message...", text: $messageText)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .clipShape(Capsule(style: .continuous))
                .overlay(
                    Capsule(style: .continuous)
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
                )

            Button {
                sendMessage()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(messageText.isEmpty ? Color.white.opacity(0.15) : RingsideTheme.gold)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .sensoryFeedback(.impact(weight: .medium), trigger: chatMessages.count)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(Color.white.opacity(0.06)),
            alignment: .top
        )
    }

    private var eventNameForFight: String {
        for event in SampleData.events {
            if event.fights.contains(where: { $0.id == fight.id }) {
                return event.name
            }
        }
        return "RINGSIDE EVENT"
    }

    private var eventSubtitle: String {
        for event in SampleData.events {
            if event.fights.contains(where: { $0.id == fight.id }) {
                return event.venue
            }
        }
        return ""
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let newMessage = ChatMessage(id: UUID().uuidString, userName: "You", text: messageText, timestamp: Date(), isCurrentUser: true, reaction: nil)
        withAnimation(.snappy) {
            chatMessages.append(newMessage)
        }
        messageText = ""
    }

    private func sendReaction(_ emoji: String) {
        let newMessage = ChatMessage(id: UUID().uuidString, userName: "You", text: emoji, timestamp: Date(), isCurrentUser: true, reaction: emoji)
        withAnimation(.snappy) {
            chatMessages.append(newMessage)
        }
    }
}

extension Fight {
    var date: Date? {
        for event in SampleData.events {
            if event.fights.contains(where: { $0.id == self.id }) {
                return event.date
            }
        }
        return nil
    }
}

struct RoundScoreRow: View {
    let score: RoundScore
    let fighterAName: String
    let fighterBName: String

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 6) {
                Text("\(score.fighterAScore)")
                    .font(.system(.subheadline, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 24)

                GeometryReader { geo in
                    let width = geo.size.width
                    let normA = score.communityAScore / 10.0
                    HStack(spacing: 0) {
                        Spacer()
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                LinearGradient(
                                    colors: [RingsideTheme.gold.opacity(0.5), RingsideTheme.gold.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: width * normA)
                    }
                }
                .frame(height: 6)
            }
            .frame(maxWidth: .infinity)

            Text("\(score.round)")
                .font(.system(.caption, weight: .bold))
                .foregroundStyle(RingsideTheme.gold)
                .frame(width: 30)

            HStack(spacing: 6) {
                GeometryReader { geo in
                    let width = geo.size.width
                    let normB = score.communityBScore / 10.0
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                LinearGradient(
                                    colors: [RingsideTheme.liveRed.opacity(0.8), RingsideTheme.liveRed.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: width * normB)
                        Spacer()
                    }
                }
                .frame(height: 6)

                Text("\(score.fighterBScore)")
                    .font(.system(.subheadline, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 24)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

struct StatComparisonRow: View {
    let label: String
    let valueA: Double
    let valueB: Double
    let nameA: String
    let nameB: String

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("\(Int(valueA * 100))")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(valueA >= valueB ? RingsideTheme.gold : .white.opacity(0.4))
                Spacer()
                Text(label.uppercased())
                    .font(.system(.caption2, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.4))
                Spacer()
                Text("\(Int(valueB * 100))")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(valueB > valueA ? RingsideTheme.liveRed : .white.opacity(0.4))
            }

            GeometryReader { geo in
                let totalWidth = geo.size.width
                let halfWidth = totalWidth / 2 - 2
                HStack(spacing: 4) {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                LinearGradient(
                                    colors: [RingsideTheme.gold.opacity(0.5), RingsideTheme.gold.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: halfWidth * valueA)
                    }
                    .frame(width: halfWidth)

                    HStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                LinearGradient(
                                    colors: [RingsideTheme.liveRed.opacity(0.9), RingsideTheme.liveRed.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: halfWidth * valueB)
                        Spacer()
                    }
                    .frame(width: halfWidth)
                }
            }
            .frame(height: 8)
            .background(Color.white.opacity(0.04))
            .clipShape(.rect(cornerRadius: 4))
        }
    }
}

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isCurrentUser { Spacer(minLength: 60) }

            VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 4) {
                if !message.isCurrentUser {
                    Text(message.userName)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                }

                Text(message.text)
                    .font(.subheadline)
                    .foregroundStyle(message.isCurrentUser ? .black : .white.opacity(0.9))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Group {
                            if message.isCurrentUser {
                                LinearGradient(
                                    colors: [RingsideTheme.gold, RingsideTheme.darkGold],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            } else {
                                Color.white.opacity(0.06)
                            }
                        }
                    )
                    .clipShape(.rect(cornerRadius: 18, style: .continuous))
                    .overlay(
                        Group {
                            if !message.isCurrentUser {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
                            }
                        }
                    )

                Text(message.timestamp, format: .dateTime.hour().minute())
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.2))
            }

            if !message.isCurrentUser { Spacer(minLength: 60) }
        }
    }
}
