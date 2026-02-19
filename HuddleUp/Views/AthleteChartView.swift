import SwiftUI
import Charts

struct AthleteChartView: View {
    let athlete: Athlete

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // TOUCHDOWN TREND (Line Chart)
            if athlete.stats.contains(where: { $0.touchdowns != nil }) {
                ChartSection(title: "Touchdowns by Season") {
                    Chart(athlete.stats.sorted { $0.season < $1.season }) { stat in
                        if let tds = stat.touchdowns {
                            LineMark(
                                x: .value("Season", String(stat.season)),
                                y: .value("TDs", tds)
                            )
                            .foregroundStyle(.blue)
                            .symbol(Circle())

                            PointMark(
                                x: .value("Season", String(stat.season)),
                                y: .value("TDs", tds)
                            )
                            .foregroundStyle(.blue)
                            .annotation(position: .top) {
                                Text("\(tds)")
                                    .font(.caption2.bold())
                            }
                        }
                    }
                    .frame(height: 200)
                }
            }

            // GAMES PLAYED (Bar Chart)
            ChartSection(title: "Games Played") {
                Chart(athlete.stats.sorted { $0.season < $1.season }) { stat in
                    BarMark(
                        x: .value("Season", String(stat.season)),
                        y: .value("Games", stat.gamesPlayed)
                    )
                    .foregroundStyle(.green.gradient)
                    .cornerRadius(6)
                }
                .frame(height: 200)
            }

            // YARDS BREAKDOWN (Stacked Bar — if applicable)
            if athlete.stats.contains(where: { ($0.rushingYards ?? 0) + ($0.passingYards ?? 0) > 0 }) {
                ChartSection(title: "Yards Breakdown") {
                    Chart(athlete.stats.sorted { $0.season < $1.season }) { stat in
                        if let rush = stat.rushingYards {
                            BarMark(
                                x: .value("Season", String(stat.season)),
                                y: .value("Yards", rush)
                            )
                            .foregroundStyle(by: .value("Type", "Rushing"))
                        }
                        if let pass = stat.passingYards {
                            BarMark(
                                x: .value("Season", String(stat.season)),
                                y: .value("Yards", pass)
                            )
                            .foregroundStyle(by: .value("Type", "Passing"))
                        }
                    }
                    .chartForegroundStyleScale([
                        "Rushing": .orange,
                        "Passing": .purple
                    ])
                    .frame(height: 200)
                }
            }
        }
        .padding()
    }
}

// Reusable chart wrapper
struct ChartSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            content
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
