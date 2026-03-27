import SwiftUI

struct ProfileView: View {
    @State private var spoilerFreeMode: Bool = false
    @State private var showSettings: Bool = false
    private let profile = SampleData.userProfile

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    profileHeader
                    statsRow
                    badgesSection
                    recentActivitySection
                }
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            .background(Color.clear)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsSheet(spoilerFreeMode: $spoilerFreeMode)
                    .presentationDetents([.medium])
            }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [RingsideTheme.gold.opacity(0.2), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 60
                        )
                    )
                    .frame(width: 100, height: 100)

                Text(profile.avatarEmoji)
                    .font(.system(size: 48))
                    .frame(width: 88, height: 88)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .overlay(
                        Circle().strokeBorder(
                            LinearGradient(
                                colors: [RingsideTheme.gold.opacity(0.5), RingsideTheme.gold.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                    )
            }

            VStack(spacing: 4) {
                Text(profile.displayName)
                    .font(.system(.title2, weight: .bold))
                    .foregroundStyle(.white)
                Text(profile.username)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.4))
            }

            HStack(spacing: 40) {
                VStack(spacing: 2) {
                    Text("\(profile.followers)")
                        .font(.system(.headline, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Followers")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }
                VStack(spacing: 2) {
                    Text("\(profile.following)")
                        .font(.system(.headline, weight: .bold))
                        .foregroundStyle(.white)
                    Text("Following")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.4))
                }
            }

            Button {
            } label: {
                Text("Edit Profile")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
                    )
            }
            .padding(.horizontal)
        }
        .padding(.top, 16)
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            StatItem(value: "\(profile.fightsScored)", label: "Fights Scored", icon: "sportscourt.fill")
            StatItem(value: String(format: "%.1f", profile.averageRating), label: "Avg Rating", icon: "star.fill")
            StatItem(value: "\(profile.posts)", label: "Posts", icon: "text.bubble.fill")
        }
        .padding(16)
        .glassGoldCard()
        .padding(.horizontal)
    }

    private var badgesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("BADGES")
                .font(.system(.caption, weight: .bold).width(.compressed))
                .foregroundStyle(.white.opacity(0.4))
                .padding(.horizontal)

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(profile.badges) { badge in
                        BadgeCard(badge: badge)
                    }
                }
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.hidden)
        }
    }

    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RECENT ACTIVITY")
                .font(.system(.caption, weight: .bold).width(.compressed))
                .foregroundStyle(.white.opacity(0.4))
                .padding(.horizontal)

            VStack(spacing: 8) {
                ForEach(profile.recentActivity) { item in
                    ActivityRow(item: item)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(RingsideTheme.gold)
            Text(value)
                .font(.system(.title3, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }
}

struct BadgeCard: View {
    let badge: Badge

    private var badgeColor: Color {
        switch badge.color {
        case "gold": return RingsideTheme.gold
        case "blue": return .blue
        case "red": return RingsideTheme.liveRed
        case "purple": return .purple
        default: return .gray
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.08), lineWidth: 4)
                    .frame(width: 56, height: 56)
                Circle()
                    .trim(from: 0, to: badge.progress)
                    .stroke(badgeColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(-90))
                Image(systemName: badge.icon)
                    .font(.title3)
                    .foregroundStyle(badgeColor)
            }
            Text(badge.name)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
            Text("\(Int(badge.progress * 100))%")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.4))
        }
        .frame(width: 100)
        .padding(.vertical, 16)
        .glassCard(cornerRadius: 16)
    }
}

struct ActivityRow: View {
    let item: ActivityItem

    private var icon: String {
        switch item.type {
        case .scorecard: return "list.number"
        case .post: return "text.bubble.fill"
        case .badge: return "medal.fill"
        }
    }

    private var iconColor: Color {
        switch item.type {
        case .scorecard: return .blue
        case .post: return .green
        case .badge: return RingsideTheme.gold
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(iconColor)
                .frame(width: 36, height: 36)
                .background(iconColor.opacity(0.12))
                .clipShape(.rect(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.35))
                    .lineLimit(1)
            }

            Spacer()

            Text(item.timestamp, style: .relative)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.25))
        }
        .padding(12)
        .glassCard(cornerRadius: 14)
    }
}

struct SettingsSheet: View {
    @Binding var spoilerFreeMode: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $spoilerFreeMode) {
                        HStack(spacing: 12) {
                            Image(systemName: "eye.slash.fill")
                                .foregroundStyle(RingsideTheme.gold)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Spoiler-Free Mode")
                                    .font(.subheadline.weight(.medium))
                                Text("Hide results until you're ready")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .tint(RingsideTheme.gold)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
