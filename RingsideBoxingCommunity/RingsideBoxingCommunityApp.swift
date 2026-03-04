import SwiftUI

@main
struct RingsideBoxingCommunityApp: App {
    @State private var dataService = BoxingDataService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataService)
        }
    }
}
