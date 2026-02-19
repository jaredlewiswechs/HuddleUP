import Foundation

struct HudlCSVParser {

    /// Parse a Hudl-style CSV string into Athlete objects.
    ///
    /// Expected CSV columns (adjust to match your actual Hudl export):
    /// Name, Position, School, Grad Year, Season, Games, Tackles, Receptions,
    /// Passing Yards, Rushing Yards, Touchdowns
    static func parse(csv: String) -> [Athlete] {
        let rows = csv.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }

        guard rows.count > 1 else { return [] }

        // First row = headers
        let headers = rows[0]
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces).lowercased() }

        // Build a column index map
        var col: [String: Int] = [:]
        for (i, header) in headers.enumerated() {
            col[header] = i
        }

        // Group rows by athlete name (one athlete may have multiple seasons)
        var athleteMap: [String: Athlete] = [:]

        for row in rows.dropFirst() {
            let fields = parseCSVRow(row)
            guard fields.count >= headers.count else { continue }

            let name = field(fields, col, "name") ?? "Unknown"
            let position = field(fields, col, "position") ?? "Unknown"
            let school = field(fields, col, "school") ?? ""
            let gradYear = intField(fields, col, "grad year") ?? 2026
            let season = intField(fields, col, "season") ?? 2025

            let stat = SeasonStat(
                id: UUID(),
                season: season,
                gamesPlayed: intField(fields, col, "games") ?? 0,
                tackles: intField(fields, col, "tackles"),
                receptions: intField(fields, col, "receptions"),
                passingYards: intField(fields, col, "passing yards"),
                rushingYards: intField(fields, col, "rushing yards"),
                touchdowns: intField(fields, col, "touchdowns")
            )

            if var existing = athleteMap[name] {
                existing.stats.append(stat)
                athleteMap[name] = existing
            } else {
                athleteMap[name] = Athlete(
                    id: UUID(),
                    name: name,
                    position: position,
                    school: school,
                    graduationYear: gradYear,
                    profileImageName: nil,
                    stats: [stat]
                )
            }
        }

        return Array(athleteMap.values)
    }

    // MARK: - Helpers

    /// Handle quoted CSV fields (commas inside quotes)
    private static func parseCSVRow(_ row: String) -> [String] {
        var fields: [String] = []
        var current = ""
        var inQuotes = false

        for char in row {
            if char == "\"" {
                inQuotes.toggle()
            } else if char == "," && !inQuotes {
                fields.append(current.trimmingCharacters(in: .whitespaces))
                current = ""
            } else {
                current.append(char)
            }
        }
        fields.append(current.trimmingCharacters(in: .whitespaces))
        return fields
    }

    private static func field(_ fields: [String], _ col: [String: Int], _ key: String) -> String? {
        guard let i = col[key], i < fields.count else { return nil }
        let val = fields[i]
        return val.isEmpty ? nil : val
    }

    private static func intField(_ fields: [String], _ col: [String: Int], _ key: String) -> Int? {
        guard let str = field(fields, col, key) else { return nil }
        return Int(str)
    }
}
