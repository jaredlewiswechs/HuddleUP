import SwiftUI

@main
struct HuddleUpApp: App {
    @State private var store = AthleteStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
