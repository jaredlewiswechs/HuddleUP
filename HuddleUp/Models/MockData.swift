import Foundation

struct MockData {
    static let athletes: [Athlete] = [
        Athlete(
            id: UUID(),
            name: "Marcus Johnson",
            position: "Wide Receiver",
            school: "Worthing HS",
            graduationYear: 2026,
            profileImageName: "marcus_placeholder",
            stats: [
                SeasonStat(id: UUID(), season: 2025, gamesPlayed: 10,
                           tackles: nil, receptions: 48, passingYards: nil,
                           rushingYards: 120, touchdowns: 7),
                SeasonStat(id: UUID(), season: 2024, gamesPlayed: 9,
                           tackles: nil, receptions: 32, passingYards: nil,
                           rushingYards: 80, touchdowns: 4)
            ]
        ),
        Athlete(
            id: UUID(),
            name: "DeAndre Williams",
            position: "Linebacker",
            school: "Yates HS",
            graduationYear: 2026,
            profileImageName: nil,
            stats: [
                SeasonStat(id: UUID(), season: 2025, gamesPlayed: 10,
                           tackles: 87, receptions: nil, passingYards: nil,
                           rushingYards: nil, touchdowns: 2)
            ]
        )
    ]
}
