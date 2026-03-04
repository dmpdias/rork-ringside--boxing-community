import SwiftUI

struct RingsideTheme {
    static let gold = Color(red: 0.91, green: 0.74, blue: 0.27)
    static let darkGold = Color(red: 0.72, green: 0.56, blue: 0.15)
    static let liveRed = Color(red: 0.95, green: 0.22, blue: 0.22)
    static let deepBackground = Color(red: 0.04, green: 0.04, blue: 0.07)
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
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.2), radius: 12, y: 6)
            )
            .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(borderOpacity),
                                Color.white.opacity(borderOpacity * 0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
    }
}

struct GlassGoldCard: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .shadow(color: RingsideTheme.gold.opacity(0.08), radius: 16, y: 8)
            )
            .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                RingsideTheme.gold.opacity(0.3),
                                RingsideTheme.gold.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
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
                Color(red: 0.04, green: 0.04, blue: 0.07),
                Color(red: 0.06, green: 0.04, blue: 0.10),
                Color(red: 0.04, green: 0.04, blue: 0.07),
                Color(red: 0.08, green: 0.05, blue: 0.03),
                Color(red: 0.05, green: 0.05, blue: 0.10),
                Color(red: 0.04, green: 0.06, blue: 0.10),
                Color(red: 0.04, green: 0.04, blue: 0.07),
                Color(red: 0.06, green: 0.03, blue: 0.06),
                Color(red: 0.04, green: 0.04, blue: 0.07)
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
