import SwiftUI

struct EventsView: View {
    @Environment(BoxingDataService.self) private var dataService
    @State private var selectedWeekOffset: Int = 0
    @State private var carouselIndex: Int = 0
    @State private var appearAnimation: Bool = false
    @State private var autoScrollTask: Task<Void, Never>?

    private let calendar = Calendar.current

    private var weekStart: Date {
        let today = calendar.startOfDay(for: Date())
        let weekday = calendar.component(.weekday, from: today)
        let daysToMonday = (weekday == 1) ? -6 : (2 - weekday)
        let thisMonday = calendar.date(byAdding: .day, value: daysToMonday, to: today)!
        return calendar.date(byAdding: .weekOfYear, value: selectedWeekOffset, to: thisMonday)!
    }

    private var weekEnd: Date {
        calendar.date(byAdding: .day, value: 6, to: weekStart)!
    }

    private var weekLabel: String {
        let startMonth = weekStart.formatted(.dateTime.month(.abbreviated).day())
        let endMonth = weekEnd.formatted(.dateTime.month(.abbreviated).day())
        return "\(startMonth) – \(endMonth)"
    }

    private var isCurrentWeek: Bool {
        selectedWeekOffset == 0
    }

    private var eventsThisWeek: [Event] {
        dataService.events.filter { event in
            let eventDay = calendar.startOfDay(for: event.date)
            return eventDay >= weekStart && eventDay <= weekEnd
        }.sorted { $0.date < $1.date }
    }

    private var allFightsThisWeek: [Fight] {
        eventsThisWeek.flatMap(\.fights)
    }

    private var topFights: [Fight] {
        Array(allFightsThisWeek.sorted { $0.commentCount > $1.commentCount }.prefix(3))
    }

    private var eventsByDay: [(date: Date, events: [Event])] {
        let grouped = Dictionary(grouping: eventsThisWeek) { event in
            calendar.startOfDay(for: event.date)
        }
        return grouped.sorted { $0.key < $1.key }.map { (date: $0.key, events: $0.value) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    weekNavigator

                    if !topFights.isEmpty {
                        topFightsSection
                    }

                    weeklyCardsSection
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
                startAutoScroll()
            }
            .onDisappear {
                autoScrollTask?.cancel()
                autoScrollTask = nil
            }
            .onChange(of: selectedWeekOffset) { _, _ in
                carouselIndex = 0
            }
        }
    }

    private var headerSection: some View {
        Text("EVENTS")
            .font(.system(size: 38, weight: .black, design: .default).width(.compressed))
            .foregroundStyle(
                LinearGradient(
                    colors: [.white, RingsideTheme.gold.opacity(0.9)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .padding(.horizontal)
            .padding(.top, 8)
            .opacity(appearAnimation ? 1 : 0)
            .offset(y: appearAnimation ? 0 : 10)
    }

    private var weekNavigator: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.snappy(duration: 0.3)) {
                    selectedWeekOffset -= 1
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 44, height: 44)
            }

            Spacer()

            VStack(spacing: 2) {
                if isCurrentWeek {
                    Text("THIS WEEK")
                        .font(.system(.caption, weight: .heavy).width(.compressed))
                        .foregroundStyle(RingsideTheme.gold)
                }
                Text(weekLabel)
                    .font(.system(.subheadline, weight: .semibold))
                    .foregroundStyle(.white.opacity(isCurrentWeek ? 0.7 : 0.5))
            }
            .contentTransition(.numericText())

            Spacer()

            Button {
                withAnimation(.snappy(duration: 0.3)) {
                    selectedWeekOffset += 1
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            Capsule(style: .continuous)
                .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
        )
        .padding(.horizontal)
        .sensoryFeedback(.selection, trigger: selectedWeekOffset)
    }

    private var topFightsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .font(.caption)
                    .foregroundStyle(RingsideTheme.gold)
                Text("TOP FIGHTS THIS WEEK")
                    .font(.system(.caption, weight: .heavy).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold)
                Spacer()
                HStack(spacing: 6) {
                    ForEach(0..<topFights.count, id: \.self) { i in
                        Circle()
                            .fill(i == carouselIndex ? RingsideTheme.gold : Color.white.opacity(0.2))
                            .frame(width: 6, height: 6)
                    }
                }
            }
            .padding(.horizontal)

            TabView(selection: $carouselIndex) {
                ForEach(Array(topFights.enumerated()), id: \.element.id) { index, fight in
                    TopFightCard(fight: fight, rank: index + 1)
                        .padding(.horizontal)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 200)
            .animation(.easeInOut(duration: 0.5), value: carouselIndex)
        }
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : 15)
    }

    @ViewBuilder
    private var weeklyCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundStyle(RingsideTheme.gold)
                Text("SCHEDULE")
                    .font(.system(.caption, weight: .heavy).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold)
                Spacer()
                Text("\(allFightsThisWeek.count) fights")
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(.white.opacity(0.35))
            }
            .padding(.horizontal)

            if eventsByDay.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.2))
                    Text("No events this week")
                        .font(.system(.headline, weight: .bold).width(.compressed))
                        .foregroundStyle(.white.opacity(0.3))
                    Text("Try another week")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.2))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(Array(eventsByDay.enumerated()), id: \.element.date) { index, dayGroup in
                        VStack(alignment: .leading, spacing: 10) {
                            dayHeader(for: dayGroup.date)

                            ForEach(dayGroup.events) { event in
                                EventsPageCard(event: event)
                            }
                        }
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.1), value: appearAnimation)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func dayHeader(for date: Date) -> some View {
        HStack(spacing: 8) {
            if calendar.isDateInToday(date) {
                Text("TODAY")
                    .font(.system(.caption, weight: .heavy).width(.compressed))
                    .foregroundStyle(RingsideTheme.liveRed)
            }
            Text(date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day()))
                .font(.system(.caption, weight: .bold))
                .foregroundStyle(.white.opacity(0.5))
            
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 0.5)
        }
    }

    private func startAutoScroll() {
        autoScrollTask?.cancel()
        autoScrollTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(2.5))
                guard !Task.isCancelled, !topFights.isEmpty else { continue }
                withAnimation(.easeInOut(duration: 0.5)) {
                    carouselIndex = (carouselIndex + 1) % topFights.count
                }
            }
        }
    }
}

struct TopFightCard: View {
    let fight: Fight
    let rank: Int

    var body: some View {
        NavigationLink(value: fight) {
            VStack(spacing: 0) {
                HStack {
                    HStack(spacing: 6) {
                        Text("#\(rank)")
                            .font(.system(.caption, weight: .black).width(.compressed))
                            .foregroundStyle(RingsideTheme.gold)
                        Text("MOST HYPED")
                            .font(.system(size: 10, weight: .bold).width(.compressed))
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right.fill")
                            .font(.system(size: 9))
                            .foregroundStyle(.white.opacity(0.3))
                        Text("\(fight.commentCount, format: .number)")
                            .font(.system(.caption2, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)

                HStack(spacing: 0) {
                    VStack(spacing: 8) {
                        FighterAvatar(imageURL: fight.fighterA.imageURL, name: fight.fighterA.name, size: 56)
                            .overlay(
                                Circle()
                                    .strokeBorder(RingsideTheme.gold.opacity(0.3), lineWidth: 1)
                            )
                        Text(fight.fighterA.name.components(separatedBy: " ").last ?? "")
                            .font(.system(.headline, weight: .heavy).width(.compressed))
                            .foregroundStyle(.white)
                        Text(fight.fighterA.record)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)

                    VStack(spacing: 4) {
                        Text("VS")
                            .font(.system(.title3, weight: .black).width(.compressed))
                            .foregroundStyle(RingsideTheme.gold)
                        Text(fight.weightClass.rawValue.uppercased())
                            .font(.system(size: 9, weight: .bold).width(.compressed))
                            .foregroundStyle(RingsideTheme.gold.opacity(0.5))
                    }

                    VStack(spacing: 8) {
                        FighterAvatar(imageURL: fight.fighterB.imageURL, name: fight.fighterB.name, size: 56)
                            .overlay(
                                Circle()
                                    .strokeBorder(RingsideTheme.gold.opacity(0.3), lineWidth: 1)
                            )
                        Text(fight.fighterB.name.components(separatedBy: " ").last ?? "")
                            .font(.system(.headline, weight: .heavy).width(.compressed))
                            .foregroundStyle(.white)
                        Text(fight.fighterB.record)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [RingsideTheme.gold.opacity(0.06), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .clipShape(.rect(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [RingsideTheme.gold.opacity(0.3), RingsideTheme.gold.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: RingsideTheme.gold.opacity(0.06), radius: 16, y: 8)
        }
        .buttonStyle(.plain)
    }
}

struct EventsPageCard: View {
    let event: Event

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

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(event.name)
                        .font(.system(.headline, weight: .heavy).width(.compressed))
                        .foregroundStyle(.white)
                    Text(event.venue)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }
                Spacer()
                Text("\(event.fights.count) fights")
                    .font(.system(.caption2, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.4))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Capsule(style: .continuous))
            }

            ForEach(groupedFights, id: \.section) { group in
                VStack(alignment: .leading, spacing: 8) {
                    Text(group.section.rawValue.uppercased())
                        .font(.system(size: 10, weight: .heavy).width(.compressed))
                        .foregroundStyle(.white.opacity(0.3))
                        .padding(.leading, 4)

                    ForEach(group.fights) { fight in
                        NavigationLink(value: fight) {
                            EventsFightRow(fight: fight)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(16)
        .glassCard()
    }
}

struct EventsFightRow: View {
    let fight: Fight

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                HStack(spacing: 8) {
                    FighterAvatar(imageURL: fight.fighterA.imageURL, name: fight.fighterA.name, size: 28)
                    Text(fight.fighterA.name.components(separatedBy: " ").last ?? "")
                        .font(.system(.subheadline, weight: .bold).width(.compressed))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                eventStatusBadge
                    .frame(width: 60)

                HStack(spacing: 8) {
                    Text(fight.fighterB.name.components(separatedBy: " ").last ?? "")
                        .font(.system(.subheadline, weight: .bold).width(.compressed))
                        .foregroundStyle(.white)
                    FighterAvatar(imageURL: fight.fighterB.imageURL, name: fight.fighterB.name, size: 28)
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
        .padding(12)
        .background(Color.white.opacity(0.04))
        .clipShape(.rect(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
        )
    }

    @ViewBuilder
    private var eventStatusBadge: some View {
        switch fight.status {
        case .live:
            HStack(spacing: 4) {
                LiveDot()
                Text("LIVE")
                    .font(.system(.caption2, weight: .bold))
                    .foregroundStyle(RingsideTheme.liveRed)
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
