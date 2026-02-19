import SwiftUI

struct ContentView: View {
    @Environment(AthleteStore.self) private var store

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.athletes) { athlete in
                    NavigationLink(value: athlete.id) {
                        AthleteRow(athlete: athlete)
                    }
                }
                .onDelete(perform: store.deleteAthlete)
            }
            .navigationTitle("Athletes")
            .navigationDestination(for: UUID.self) { athleteID in
                if let athlete = store.athletes.first(where: { $0.id == athleteID }) {
                    AthleteDetailView(athlete: athlete)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: HudlImportView()) {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                }
            }
        }
    }
}
