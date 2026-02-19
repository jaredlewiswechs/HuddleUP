import Foundation

struct Athlete: Identifiable, Codable {
    let id: UUID
    var name: String
    var position: String
    var school: String
    var graduationYear: Int
    var profileImageName: String? // local asset name or URL later

    // Hudl-sourced stats
    var stats: [SeasonStat]

    // Computed
    var latestSeason: SeasonStat? {
        stats.sorted { $0.season > $1.season }.first
    }
}

struct SeasonStat: Identifiable, Codable {
    let id: UUID
    var season: Int          // e.g. 2025
    var gamesPlayed: Int
    var tackles: Int?
    var receptions: Int?
    var passingYards: Int?
    var rushingYards: Int?
    var touchdowns: Int?

    // Add whatever Hudl gives you — keep it flat
}
