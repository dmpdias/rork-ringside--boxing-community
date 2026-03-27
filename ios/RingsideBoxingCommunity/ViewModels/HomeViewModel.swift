import SwiftUI

@Observable
class HomeViewModel {
    var expandedEventIds: Set<String> = []

    func isExpanded(_ eventId: String) -> Bool {
        expandedEventIds.contains(eventId)
    }

    func toggleExpanded(_ eventId: String) {
        if expandedEventIds.contains(eventId) {
            expandedEventIds.remove(eventId)
        } else {
            expandedEventIds.insert(eventId)
        }
    }
}
