import SwiftUI

struct HomeView: View {
    @Environment(BoxingDataService.self) private var dataService
    @State private var selectedFilter: FightStatus? = nil
    @State private var appearAnimation: Bool = false
    @State private var selectedDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var viewModel = HomeViewModel()

    private let calendar = Calendar.current

    private var eventsForSelectedDate: [Event] {
        dataService.events.filter { calendar.isDate($0.date, inSameDayAs: selectedDate) }
    }

    private var filteredEvents: [Event] {
        let dayEvents = eventsForSelectedDate
        guard let filter = selectedFilter else { return dayEvents }
        return dayEvents.compactMap { event in
            let filtered = event.fights.filter { $0.status == filter }
            guard !filtered.isEmpty else { return nil }
            return Event(id: event.id, name: event.name, date: event.date, venue: event.venue, fights: filtered, isMainEvent: event.isMainEvent)
        }
    }

    private var isToday: Bool {
        calendar.isDateInToday(selectedDate)
    }

    private var hasLiveFight: Bool {
        eventsForSelectedDate.flatMap(\.fights).contains { $0.status == .live }
    }

    private var liveFightForDate: Fight? {
        eventsForSelectedDate.flatMap(\.fights).first { $0.status == .live }
    }

    private var highlightForDate: FighterHighlight? {
        RealBoxingData.highlightForDate(selectedDate)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    dateNavigator
                    if let live = liveFightForDate {
                        liveBannerView(fight: live)
                    }
                    if let highlight = highlightForDate {
                        fighterOfTheDaySection(highlight: highlight)
                    }
                    eventsHeader
                    eventsList
                }
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            .background(Color.clear)
            .refreshable {
                dataService.refresh()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Fight.self) { fight in
                FightDetailView(fight: fight)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    appearAnimation = true
                }
            }

        }
    }

    private var headerSection: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Text("FIGHT NIGHT")
                .font(.system(size: 38, weight: .black, design: .default).width(.compressed))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, RingsideTheme.gold.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Image(systemName: "figure.boxing")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(RingsideTheme.gloveRed)
                .offset(y: -4)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : 10)
    }

    private var dateNavigator: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.snappy(duration: 0.3)) {
                    selectedDate = calendar.date(byAdding: .day, value: -1, to: selectedDate)!
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(.body, weight: .bold))
                    .foregroundStyle(RingsideTheme.gold.opacity(0.7))
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(RingsideTheme.charcoalLight.opacity(0.6))
                    )
            }

            Spacer()

            VStack(spacing: 3) {
                if isToday {
                    Text("TODAY")
                        .font(.system(.caption, weight: .heavy).width(.compressed))
                        .tracking(1.5)
                        .foregroundStyle(RingsideTheme.gold)
                }
                Text(selectedDate, format: .dateTime.weekday(.wide).month(.abbreviated).day())
                    .font(.system(.subheadline, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [RingsideTheme.gold.opacity(0.85), .white.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .contentTransition(.numericText())

            Spacer()

            Button {
                withAnimation(.snappy(duration: 0.3)) {
                    selectedDate = calendar.date(byAdding: .day, value: 1, to: selectedDate)!
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(.body, weight: .bold))
                    .foregroundStyle(RingsideTheme.gold.opacity(0.7))
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(RingsideTheme.charcoalLight.opacity(0.6))
                    )
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(RingsideTheme.charcoal)
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.4))
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [RingsideTheme.gold.opacity(0.06), .clear, RingsideTheme.gold.opacity(0.03)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .clipShape(.rect(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            RingsideTheme.gold.opacity(0.5),
                            RingsideTheme.gold.opacity(0.15),
                            RingsideTheme.gold.opacity(0.35)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.75
                )
        )
        .shadow(color: RingsideTheme.gold.opacity(0.08), radius: 14, y: 5)
        .padding(.horizontal)
        .sensoryFeedback(.selection, trigger: selectedDate)
    }

    private func liveBannerView(fight: Fight) -> some View {
        NavigationLink(value: fight) {
            VStack(spacing: 0) {
                HStack {
                    HStack(spacing: 6) {
                        LiveDot()
                        Text("LIVE NOW")
                            .font(.system(.caption, weight: .heavy).width(.compressed))
                            .tracking(1)
                            .foregroundStyle(RingsideTheme.gloveRed)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(RingsideTheme.gloveRed.opacity(0.15))
                    )
                    .overlay(
                        Capsule(style: .continuous)
                            .strokeBorder(RingsideTheme.gloveRed.opacity(0.35), lineWidth: 0.75)
                    )

                    Spacer()

                    HStack(spacing: 5) {
                        Image(systemName: "eye.fill")
                            .font(.system(size: 10))
                        Text("\(fight.viewerCount ?? 0, format: .number)")
                            .font(.system(.caption2, weight: .bold))
                    }
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(RingsideTheme.charcoalLight.opacity(0.8))
                    )
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 16)

                VStack(spacing: 14) {
                    HStack(spacing: 0) {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [RingsideTheme.gloveRed.opacity(0.25), RingsideTheme.gloveRed.opacity(0.05), .clear],
                                            center: .center,
                                            startRadius: 10,
                                            endRadius: 44
                                        )
                                    )
                                    .frame(width: 76, height: 76)
                                FighterAvatar(imageURL: fight.fighterA.imageURL, size: 58)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(
                                                LinearGradient(
                                                    colors: [RingsideTheme.gloveRed.opacity(0.6), RingsideTheme.gold.opacity(0.3)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )
                                    .shadow(color: RingsideTheme.gloveRed.opacity(0.3), radius: 10, y: 4)
                            }
                            Text(fight.fighterA.name.components(separatedBy: " ").last ?? "")
                                .font(.system(.title2, weight: .heavy).width(.compressed))
                                .foregroundStyle(.white)
                            Text(fight.fighterA.record)
                                .font(.system(.caption2, weight: .medium))
                                .foregroundStyle(.white.opacity(0.35))
                        }
                        .frame(maxWidth: .infinity)

                        VStack(spacing: 6) {
                            Text("V S")
                                .font(.system(size: 22, weight: .black, design: .default).width(.compressed))
                                .tracking(6)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [RingsideTheme.gold, RingsideTheme.gold.opacity(0.6)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .shadow(color: RingsideTheme.gold.opacity(0.3), radius: 8)
                            Text("RD \(fight.currentRound ?? 1) / \(fight.scheduledRounds)")
                                .font(.system(.caption2, weight: .heavy).width(.compressed))
                                .tracking(1)
                                .foregroundStyle(RingsideTheme.gold.opacity(0.5))
                        }
                        .frame(width: 70)

                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            colors: [RingsideTheme.gold.opacity(0.15), RingsideTheme.gold.opacity(0.03), .clear],
                                            center: .center,
                                            startRadius: 10,
                                            endRadius: 44
                                        )
                                    )
                                    .frame(width: 76, height: 76)
                                FighterAvatar(imageURL: fight.fighterB.imageURL, size: 58)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(
                                                LinearGradient(
                                                    colors: [RingsideTheme.gold.opacity(0.5), RingsideTheme.gold.opacity(0.15)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                ),
                                                lineWidth: 1.5
                                            )
                                    )
                                    .shadow(color: RingsideTheme.gold.opacity(0.2), radius: 10, y: 4)
                            }
                            Text(fight.fighterB.name.components(separatedBy: " ").last ?? "")
                                .font(.system(.title2, weight: .heavy).width(.compressed))
                                .foregroundStyle(.white)
                            Text(fight.fighterB.record)
                                .font(.system(.caption2, weight: .medium))
                                .foregroundStyle(.white.opacity(0.35))
                        }
                        .frame(maxWidth: .infinity)
                    }

                    Text(fight.weightClass.rawValue.uppercased())
                        .font(.system(.caption2, weight: .heavy).width(.compressed))
                        .tracking(2)
                        .foregroundStyle(RingsideTheme.gold.opacity(0.4))
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 22)
            }
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(RingsideTheme.charcoalDark)

                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.thickMaterial.opacity(0.4))

                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            RadialGradient(
                                colors: [RingsideTheme.gloveRed.opacity(0.22), RingsideTheme.gloveRed.opacity(0.05), .clear],
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 300
                            )
                        )

                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [RingsideTheme.gold.opacity(0.05), .clear, RingsideTheme.gloveRed.opacity(0.04)],
                                startPoint: .bottomTrailing,
                                endPoint: .topLeading
                            )
                        )
                }
            }
            .clipShape(.rect(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                RingsideTheme.gloveRed.opacity(0.6),
                                RingsideTheme.gold.opacity(0.35),
                                RingsideTheme.gold.opacity(0.2),
                                RingsideTheme.gloveRed.opacity(0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: RingsideTheme.gloveRed.opacity(0.2), radius: 28, y: 12)
            .shadow(color: RingsideTheme.gold.opacity(0.06), radius: 14, y: 5)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : 20)
    }

    private func fighterOfTheDaySection(highlight: FighterHighlight) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .font(.caption)
                    .foregroundStyle(RingsideTheme.gloveRed)
                Text("HIGHLIGHT OF THE DAY")
                    .font(.system(.caption, weight: .heavy).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold)
            }
            .padding(.horizontal)

            HStack(spacing: 14) {
                FighterAvatar(imageURL: highlight.fighter.imageURL, size: 64)
                    .overlay(
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [RingsideTheme.gold, RingsideTheme.gold.opacity(0.3)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 2
                            )
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(highlight.fighter.name)
                        .font(.system(.headline, weight: .heavy).width(.compressed))
                        .foregroundStyle(.white)
                    Text(highlight.fighter.nickname.isEmpty ? highlight.fightContext : "\"\(highlight.fighter.nickname)\"")
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                    Text(highlight.fightContext)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.35))
                }

                Spacer()

                VStack(spacing: 2) {
                    Text(String(format: "%.1f", highlight.grade))
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(RingsideTheme.gold)
                    Text("GRADE")
                        .font(.system(size: 9, weight: .bold).width(.compressed))
                        .foregroundStyle(.white.opacity(0.35))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [RingsideTheme.gold.opacity(0.1), RingsideTheme.gloveRed.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(.rect(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(RingsideTheme.gold.opacity(0.3), lineWidth: 0.75)
                )
            }
            .padding(14)
            .glassGoldCard()
            .padding(.horizontal)
        }
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : 15)
    }

    private var eventsHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundStyle(RingsideTheme.gold)
                Text("EVENTS OF THE DAY")
                    .font(.system(.caption, weight: .heavy).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold)
                Spacer()
                Text("\(eventsForSelectedDate.flatMap(\.fights).count) fights")
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(.white.opacity(0.35))
            }
            .padding(.horizontal)

            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    FilterChip(title: "All", isSelected: selectedFilter == nil) {
                        withAnimation(.snappy) { selectedFilter = nil }
                    }
                    ForEach(FightStatus.allCases, id: \.rawValue) { status in
                        FilterChip(title: status.displayLabel, isSelected: selectedFilter == status, isLive: status == .live) {
                            withAnimation(.snappy) { selectedFilter = status }
                        }
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)
        }
    }

    @ViewBuilder
    private var eventsList: some View {
        if filteredEvents.isEmpty {
            VStack(spacing: 16) {
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.system(size: 40))
                    .foregroundStyle(RingsideTheme.gloveRed.opacity(0.3))
                Text("No events scheduled")
                    .font(.system(.headline, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.3))
                Text("Check back or browse another day")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.2))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 60)
        } else {
            LazyVStack(spacing: 16) {
                ForEach(Array(filteredEvents.enumerated()), id: \.element.id) { index, event in
                    EventCard(event: event, viewModel: viewModel)
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.1), value: appearAnimation)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct LiveDot: View {
    @State private var isPulsing: Bool = false

    var body: some View {
        Circle()
            .fill(RingsideTheme.gloveRed)
            .frame(width: 8, height: 8)
            .overlay(
                Circle()
                    .fill(RingsideTheme.gloveRed.opacity(0.4))
                    .frame(width: isPulsing ? 18 : 8, height: isPulsing ? 18 : 8)
                    .opacity(isPulsing ? 0 : 1)
            )
            .onAppear {
                withAnimation(.easeOut(duration: 1.2).repeatForever(autoreverses: false)) {
                    isPulsing = true
                }
            }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var isLive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if isLive {
                    LiveDot()
                }
                Text(title)
                    .font(.system(.subheadline, weight: .semibold))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background {
                if isSelected {
                    Capsule(style: .continuous)
                        .fill(RingsideTheme.gold.opacity(0.18))
                } else {
                    Capsule(style: .continuous)
                        .fill(RingsideTheme.charcoal)
                }
            }
            .foregroundStyle(isSelected ? RingsideTheme.gold : .white.opacity(0.6))
            .clipShape(Capsule(style: .continuous))
            .overlay(
                Capsule(style: .continuous)
                    .strokeBorder(isSelected ? RingsideTheme.gold.opacity(0.5) : RingsideTheme.gold.opacity(0.1), lineWidth: 0.75)
            )
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}

struct FighterAvatar: View {
    let imageURL: String?
    var size: CGFloat = 30

    var body: some View {
        Group {
            if let url = imageURL, let imageUrl = URL(string: url) {
                Color(.secondarySystemBackground)
                    .frame(width: size, height: size)
                    .overlay {
                        AsyncImage(url: imageUrl) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if phase.error != nil {
                                placeholderIcon
                            } else {
                                ProgressView()
                                    .tint(.white.opacity(0.3))
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    .clipShape(Circle())
            } else {
                placeholderIcon
                    .frame(width: size, height: size)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
        }
    }

    private var placeholderIcon: some View {
        Image(systemName: "person.fill")
            .font(.system(size: size * 0.4))
            .foregroundStyle(.white.opacity(0.3))
            .frame(width: size, height: size)
    }
}

struct EventCard: View {
    let event: Event
    @Bindable var viewModel: HomeViewModel

    private var isExpanded: Bool {
        viewModel.isExpanded(event.id)
    }

    private var dateString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(event.date) { return "TODAY" }
        if calendar.isDateInTomorrow(event.date) { return "TOMORROW" }
        return event.date.formatted(.dateTime.month(.abbreviated).day()).uppercased()
    }

    private var mainEventFight: Fight? {
        event.fights.first { $0.cardSection == .mainCard } ?? event.fights.first
    }

    private var groupedFights: [(section: CardSection, fights: [Fight])] {
        var groups: [(section: CardSection, fights: [Fight])] = []
        for section in CardSection.allCases {
            let sectionFights = event.fights.filter { $0.cardSection == section }
            if !sectionFights.isEmpty {
                groups.append((section: section, fights: sectionFights))
            }
        }
        return groups
    }

    private var totalFightCount: Int {
        event.fights.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.snappy(duration: 0.35)) {
                    viewModel.toggleExpanded(event.id)
                }
            } label: {
                eventHeader
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: isExpanded)

            if isExpanded {
                expandedContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                collapsedContent
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .glassCard()
    }

    private var eventHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(event.name)
                    .font(.system(.headline, weight: .heavy).width(.compressed))
                    .foregroundStyle(.white)
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                    Text(event.venue)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }
            }
            Spacer()
            HStack(spacing: 10) {
                Text(dateString)
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(RingsideTheme.gold.opacity(0.12))
                    .clipShape(Capsule(style: .continuous))
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(.white.opacity(0.4))
                    .contentTransition(.symbolEffect(.replace))
            }
        }
    }

    private var collapsedContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let mainFight = mainEventFight {
                Divider().overlay(RingsideTheme.gold.opacity(0.1))
                    .padding(.top, 10)

                FightRowCompact(fight: mainFight, eventName: event.name, venue: event.venue)

                if totalFightCount > 1 {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 10))
                        Text("\(totalFightCount - 1) more fight\(totalFightCount - 1 > 1 ? "s" : "")")
                            .font(.system(.caption2, weight: .semibold))
                    }
                    .foregroundStyle(RingsideTheme.gloveRed.opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                }
            }
        }
    }

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Divider().overlay(RingsideTheme.gold.opacity(0.1))
                .padding(.top, 10)

            ForEach(groupedFights, id: \.section) { group in
                VStack(alignment: .leading, spacing: 8) {
                    Text(group.section.rawValue.uppercased())
                        .font(.system(size: 10, weight: .heavy).width(.compressed))
                        .foregroundStyle(.white.opacity(0.3))
                        .padding(.leading, 4)
                        .padding(.top, 4)

                    ForEach(group.fights) { fight in
                        FightRowCompact(fight: fight, eventName: event.name, venue: event.venue)
                    }
                }
            }
        }
    }
}

struct FightRowCompact: View {
    let fight: Fight
    let eventName: String
    let venue: String

    var body: some View {
        NavigationLink(value: fight) {
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    HStack(spacing: 8) {
                        FighterAvatar(imageURL: fight.fighterA.imageURL, size: 28)
                        Text(fight.fighterA.name.components(separatedBy: " ").last ?? "")
                            .font(.system(.subheadline, weight: .bold).width(.compressed))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    statusBadge
                        .frame(width: 60)

                    HStack(spacing: 8) {
                        Text(fight.fighterB.name.components(separatedBy: " ").last ?? "")
                            .font(.system(.subheadline, weight: .bold).width(.compressed))
                            .foregroundStyle(.white)
                        FighterAvatar(imageURL: fight.fighterB.imageURL, size: 28)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }

                HStack {
                    Text(fight.weightClass.rawValue)
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.35))
                    Spacer()
                    HStack(spacing: 8) {
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 9))
                                .foregroundStyle(RingsideTheme.gold)
                            Text(String(format: "%.1f", fight.communityRating))
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        HStack(spacing: 3) {
                            Image(systemName: "bubble.right.fill")
                                .font(.system(size: 9))
                                .foregroundStyle(.white.opacity(0.3))
                            Text("\(fight.commentCount)")
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .padding(12)
        .background(RingsideTheme.charcoalDark.opacity(0.8))
        .clipShape(.rect(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [RingsideTheme.gold.opacity(0.2), RingsideTheme.gold.opacity(0.06)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.5
                )
        )
    }

    @ViewBuilder
    private var statusBadge: some View {
        switch fight.status {
        case .live:
            HStack(spacing: 4) {
                LiveDot()
                Text("RD \(fight.currentRound ?? 1)")
                    .font(.system(.caption2, weight: .bold))
                    .foregroundStyle(RingsideTheme.gloveRed)
            }
        case .upcoming:
            Text("\(fight.scheduledRounds) RDS")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(.white.opacity(0.4))
        case .completed:
            Text("FINAL")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(RingsideTheme.gold)
        }
    }
}

extension Fight: Hashable {
    static func == (lhs: Fight, rhs: Fight) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
