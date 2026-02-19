import Foundation

@Observable
class AthleteStore {
    var athletes: [Athlete] = []

    private let saveKey = "huddleup_athletes"

    init() {
        load()
        if athletes.isEmpty {
            athletes = MockData.athletes // fallback to mock data
        }
    }

    func addAthlete(_ athlete: Athlete) {
        athletes.append(athlete)
        save()
    }

    func deleteAthlete(at offsets: IndexSet) {
        athletes.remove(atOffsets: offsets)
        save()
    }

    // MARK: - Persistence

    private var saveURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("athletes.json")
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(athletes)
            try data.write(to: saveURL)
        } catch {
            print("Save failed: \(error)")
        }
    }

    func load() {
        do {
            let data = try Data(contentsOf: saveURL)
            athletes = try JSONDecoder().decode([Athlete].self, from: data)
        } catch {
            print("Load failed (first launch?): \(error)")
        }
    }
}
