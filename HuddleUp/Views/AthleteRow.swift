import SwiftUI

struct AthleteRow: View {
    let athlete: Athlete

    var body: some View {
        HStack(spacing: 14) {
            // Profile image or placeholder
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 50, height: 50)

                if let imageName = athlete.profileImageName {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(athlete.name)
                    .font(.headline)

                Text("\(athlete.position) \u{2022} Class of \(athlete.graduationYear)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let latest = athlete.latestSeason {
                Text("\(latest.gamesPlayed)G")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}
