import SwiftUI

struct RingsideTheme {
    static let gold = Color(red: 0.91, green: 0.74, blue: 0.27)
    static let darkGold = Color(red: 0.72, green: 0.56, blue: 0.15)
    static let liveRed = Color(red: 0.95, green: 0.22, blue: 0.22)
    static let boxingRed = Color(red: 0.78, green: 0.12, blue: 0.12)
    static let gloveRed = Color(red: 0.85, green: 0.18, blue: 0.15)
    static let deepBackground = Color(red: 0.04, green: 0.04, blue: 0.07)
    static let charcoal = Color(red: 0.08, green: 0.08, blue: 0.09)
    static let charcoalLight = Color(red: 0.12, green: 0.12, blue: 0.13)
    static let charcoalDark = Color(red: 0.05, green: 0.05, blue: 0.06)
    static let surfaceBackground = Color(white: 0.09)
    static let subtleGold = Color(red: 0.91, green: 0.74, blue: 0.27).opacity(0.15)
    static let chatBubbleOther = Color(white: 0.15)
    static let glassWhite = Color.white.opacity(0.08)
    static let glassBorder = Color.white.opacity(0.12)
    static let goldGlow = Color(red: 0.91, green: 0.74, blue: 0.27).opacity(0.25)
}

struct GlassCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    var borderOpacity: Double = 0.12
    var fillOpacity: Double = 0.08

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(RingsideTheme.charcoal)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial.opacity(0.5))
                }
                .shadow(color: .black.opacity(0.35), radius: 14, y: 8)
            )
            .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                RingsideTheme.gold.opacity(0.4),
                                RingsideTheme.gold.opacity(0.1),
                                RingsideTheme.gold.opacity(0.25)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.75
                    )
            )
    }
}

struct GlassGoldCard: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(RingsideTheme.charcoal)
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [RingsideTheme.gold.opacity(0.06), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .shadow(color: RingsideTheme.gold.opacity(0.1), radius: 16, y: 8)
            )
            .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
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
    }
}

struct MeshBackgroundView: View {
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ],
            colors: [
                Color(red: 0.06, green: 0.06, blue: 0.07),
                Color(red: 0.08, green: 0.06, blue: 0.08),
                Color(red: 0.06, green: 0.06, blue: 0.07),
                Color(red: 0.10, green: 0.07, blue: 0.05),
                Color(red: 0.07, green: 0.07, blue: 0.09),
                Color(red: 0.09, green: 0.06, blue: 0.06),
                Color(red: 0.06, green: 0.06, blue: 0.07),
                Color(red: 0.08, green: 0.05, blue: 0.05),
                Color(red: 0.06, green: 0.06, blue: 0.07)
            ]
        )
        .ignoresSafeArea()
    }
}

extension View {
    func glassCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassCard(cornerRadius: cornerRadius))
    }

    func glassGoldCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(GlassGoldCard(cornerRadius: cornerRadius))
    }

    func goldCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(GlassGoldCard(cornerRadius: cornerRadius))
    }
}
