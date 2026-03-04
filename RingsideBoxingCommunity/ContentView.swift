import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        ZStack {
            MeshBackgroundView()

            TabView(selection: $selectedTab) {
                Tab("Home", systemImage: "house.fill", value: 0) {
                    HomeView()
                }
                Tab("Events", systemImage: "calendar", value: 1) {
                    EventsView()
                }
                Tab("Feed", systemImage: "bubble.left.and.bubble.right.fill", value: 2) {
                    FeedView()
                }
                Tab("Profile", systemImage: "person.fill", value: 3) {
                    ProfileView()
                }
            }
            .tint(RingsideTheme.gold)
        }
        .preferredColorScheme(.dark)
    }
}
