import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: 0) {
                HomeView()
                    .background(MeshBackgroundView())
            }
            Tab("Events", systemImage: "calendar", value: 1) {
                EventsView()
                    .background(MeshBackgroundView())
            }
            Tab("Feed", systemImage: "bubble.left.and.bubble.right.fill", value: 2) {
                FeedView()
                    .background(MeshBackgroundView())
            }
            Tab("Profile", systemImage: "person.fill", value: 3) {
                ProfileView()
                    .background(MeshBackgroundView())
            }
        }
        .tint(RingsideTheme.gold)
        .preferredColorScheme(.dark)
    }
}
