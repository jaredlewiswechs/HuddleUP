import SwiftUI

struct AthleteDetailView: View {
    let athlete: Athlete

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // HEADER
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 80, height: 80)
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(athlete.name)
                            .font(.title.bold())
                        Text(athlete.position)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                        Text("\(athlete.school) \u{2022} \(athlete.graduationYear)")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                    }
                }
                .padding(.horizontal)

                Divider()

                // STATS SECTION
                if let latest = athlete.latestSeason {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(latest.season) Season")
                            .font(.headline)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                            StatCard(label: "Games", value: "\(latest.gamesPlayed)")

                            if let td = latest.touchdowns {
                                StatCard(label: "TDs", value: "\(td)")
                            }
                            if let rec = latest.receptions {
                                StatCard(label: "Rec", value: "\(rec)")
                            }
                            if let rush = latest.rushingYards {
                                StatCard(label: "Rush Yds", value: "\(rush)")
                            }
                            if let tck = latest.tackles {
                                StatCard(label: "Tackles", value: "\(tck)")
                            }
                            if let pass = latest.passingYards {
                                StatCard(label: "Pass Yds", value: "\(pass)")
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // SEASON HISTORY — Charts
                if athlete.stats.count > 1 {
                    AthleteChartView(athlete: athlete)
                }

                // VIEW ON HUDL BUTTON
                NavigationLink(destination: HudlProfileView(athleteName: athlete.name)) {
                    Label("View on Hudl", systemImage: "globe")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.orange)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(athlete.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Reusable stat box
struct StatCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
