import SwiftUI

struct FighterDetailView: View {
    let fighter: Fighter
    @State private var vm: FighterDetailViewModel
    @State private var appearAnimation: Bool = false

    init(fighter: Fighter) {
        self.fighter = fighter
        self._vm = State(wrappedValue: FighterDetailViewModel(fighter: fighter))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                statsBar
                    .padding(.top, 20)
                    .padding(.horizontal, 16)
                if !vm.fightRecords.isEmpty {
                    fightHistorySection
                        .padding(.top, 24)
                }
            }
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .background(MeshBackgroundView())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(fighter.name.uppercased())
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .navigationDestination(for: Fight.self) { fight in
            FightDetailView(fight: fight)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                appearAnimation = true
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [RingsideTheme.gold.opacity(0.15), RingsideTheme.gloveRed.opacity(0.08), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 90
                        )
                    )
                    .frame(width: 180, height: 180)

                if let urlString = fighter.imageURL, let url = URL(string: urlString) {
                    Color.clear
                        .frame(width: 130, height: 170)
                        .overlay {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().aspectRatio(contentMode: .fill)
                                case .failure:
                                    fighterPlaceholderLarge
                                case .empty:
                                    ProgressView().tint(.white.opacity(0.3))
                                @unknown default:
                                    fighterPlaceholderLarge
                                }
                            }
                            .allowsHitTesting(false)
                        }
                        .clipShape(.rect(cornerRadius: 18))
                        .overlay(
                            LinearGradient(
                                colors: [.clear, .clear, RingsideTheme.deepBackground.opacity(0.9)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .clipShape(.rect(cornerRadius: 18))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [RingsideTheme.gold.opacity(0.5), RingsideTheme.gold.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: RingsideTheme.gold.opacity(0.15), radius: 20, y: 8)
                } else {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.06), Color.white.opacity(0.02)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: 130, height: 170)
                        .overlay {
                            VStack(spacing: 10) {
                                Image(systemName: "figure.boxing")
                                    .font(.system(size: 52))
                                    .foregroundStyle(.white.opacity(0.12))
                                Text(fighter.country)
                                    .font(.title2)
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(RingsideTheme.gold.opacity(0.2), lineWidth: 1)
                        )
                }
            }
            .opacity(appearAnimation ? 1 : 0)
            .scaleEffect(appearAnimation ? 1 : 0.9)

            VStack(spacing: 6) {
                Text(fighter.name)
                    .font(.system(size: 28, weight: .black, design: .default).width(.compressed))
                    .foregroundStyle(.white)

                if !fighter.nickname.isEmpty {
                    Text("\"\(fighter.nickname)\"")
                        .font(.system(.subheadline, weight: .medium).italic())
                        .foregroundStyle(RingsideTheme.gold.opacity(0.7))
                }

                HStack(spacing: 8) {
                    Text(fighter.country)
                        .font(.title3)
                    Text(fighter.record)
                        .font(.system(.subheadline, weight: .bold))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.top, 2)
            }
            .opacity(appearAnimation ? 1 : 0)
            .offset(y: appearAnimation ? 0 : 10)
        }
        .padding(.top, 8)
    }

    private var statsBar: some View {
        HStack(spacing: 0) {
            statCell(value: "\(vm.wins)", label: "WINS", color: .green)
            statDivider
            statCell(value: "\(vm.losses)", label: "LOSSES", color: RingsideTheme.gloveRed)
            statDivider
            statCell(value: "\(vm.draws)", label: "DRAWS", color: .white.opacity(0.5))
            statDivider
            statCell(value: vm.koRate, label: "KO RATE", color: RingsideTheme.gold)
            if vm.averageGrade > 0 {
                statDivider
                statCell(value: String(format: "%.1f", vm.averageGrade), label: "AVG GRADE", color: RingsideTheme.gold)
            }
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .glassGoldCard(cornerRadius: 16)
        .opacity(appearAnimation ? 1 : 0)
        .offset(y: appearAnimation ? 0 : 15)
    }

    private func statCell(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 9, weight: .heavy).width(.compressed))
                .foregroundStyle(.white.opacity(0.35))
        }
        .frame(maxWidth: .infinity)
    }

    private var statDivider: some View {
        Rectangle()
            .fill(RingsideTheme.gold.opacity(0.15))
            .frame(width: 0.5, height: 36)
    }

    private var fightHistorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: "list.bullet.rectangle.portrait")
                    .font(.caption)
                    .foregroundStyle(RingsideTheme.gold)
                Text("FIGHT RECORD")
                    .font(.system(.caption, weight: .heavy).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold)
                Spacer()
                Text("\(vm.fightRecords.count) fights")
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(.white.opacity(0.35))
            }
            .padding(.horizontal, 16)

            LazyVStack(spacing: 10) {
                ForEach(Array(vm.fightRecords.enumerated()), id: \.element.id) { index, record in
                    fightRecordRow(record)
                        .opacity(appearAnimation ? 1 : 0)
                        .offset(y: appearAnimation ? 0 : 15)
                        .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.06), value: appearAnimation)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func fightRecordRow(_ record: FighterFightRecord) -> some View {
        NavigationLink(value: record.fight) {
            HStack(spacing: 12) {
                resultBadge(record)

                FighterAvatar(imageURL: record.opponentImageURL, name: record.opponentName, size: 40)
                    .overlay(
                        Circle()
                            .strokeBorder(RingsideTheme.gold.opacity(0.2), lineWidth: 0.75)
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(record.opponentName)
                        .font(.system(.subheadline, weight: .heavy).width(.compressed))
                        .foregroundStyle(.white)
                    HStack(spacing: 6) {
                        if !record.opponentRecord.isEmpty {
                            Text(record.opponentRecord)
                                .font(.caption2)
                                .foregroundStyle(.white.opacity(0.35))
                        }
                        if !record.method.isEmpty {
                            Text("·")
                                .foregroundStyle(.white.opacity(0.2))
                            Text(record.method)
                                .font(.system(.caption2, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                    Text(record.date.formatted(.dateTime.month(.abbreviated).day().year()))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white.opacity(0.25))
                }

                Spacer()

                if record.communityGrade > 0 && (record.result == "W" || record.result == "L" || record.result == "D") {
                    VStack(spacing: 2) {
                        Text(String(format: "%.1f", record.communityGrade))
                            .font(.system(size: 15, weight: .black, design: .rounded))
                            .foregroundStyle(RingsideTheme.gold)
                        Text("GRADE")
                            .font(.system(size: 8, weight: .bold).width(.compressed))
                            .foregroundStyle(.white.opacity(0.25))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(RingsideTheme.gold.opacity(0.08))
                    .clipShape(.rect(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(RingsideTheme.gold.opacity(0.15), lineWidth: 0.5)
                    )
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.2))
                }
            }
            .padding(12)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(RingsideTheme.charcoalDark.opacity(0.8))
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.ultraThinMaterial.opacity(0.3))
                }
            )
            .clipShape(.rect(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [RingsideTheme.gold.opacity(0.2), RingsideTheme.gold.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
        }
        .buttonStyle(.plain)
    }

    private func resultBadge(_ record: FighterFightRecord) -> some View {
        let bgColor: Color
        let textColor: Color
        let text: String

        switch record.result {
        case "W":
            bgColor = Color.green.opacity(0.15)
            textColor = .green
            text = "W"
        case "L":
            bgColor = RingsideTheme.gloveRed.opacity(0.15)
            textColor = RingsideTheme.gloveRed
            text = "L"
        case "D":
            bgColor = Color.white.opacity(0.08)
            textColor = .white.opacity(0.5)
            text = "D"
        case "LIVE":
            bgColor = RingsideTheme.gloveRed.opacity(0.15)
            textColor = RingsideTheme.gloveRed
            text = "LIVE"
        default:
            bgColor = RingsideTheme.gold.opacity(0.1)
            textColor = RingsideTheme.gold.opacity(0.6)
            text = "TBD"
        }

        return Text(text)
            .font(.system(size: 11, weight: .black).width(.compressed))
            .foregroundStyle(textColor)
            .frame(width: 36, height: 36)
            .background(bgColor)
            .clipShape(.rect(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(textColor.opacity(0.25), lineWidth: 0.5)
            )
    }

    private var fighterPlaceholderLarge: some View {
        ZStack {
            Color.white.opacity(0.04)
            Image(systemName: "figure.boxing")
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.1))
        }
    }
}
