import SwiftUI
import UniformTypeIdentifiers

struct HudlImportView: View {
    @Environment(AthleteStore.self) private var store
    @State private var showFileImporter = false
    @State private var importResult: ImportResult?

    enum ImportResult {
        case success(Int)
        case failure(String)
    }

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "square.and.arrow.down.on.square")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Import from Hudl")
                .font(.title2.bold())

            Text("Export your athlete stats from Hudl as a CSV file, then import it here.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)

            Button {
                showFileImporter = true
            } label: {
                Label("Choose CSV File", systemImage: "doc.badge.plus")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 40)

            // Result feedback
            if let result = importResult {
                switch result {
                case .success(let count):
                    Label("\(count) athletes imported", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                case .failure(let msg):
                    Label(msg, systemImage: "xmark.circle.fill")
                        .foregroundStyle(.red)
                }
            }
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [UTType.commaSeparatedText, UTType.plainText],
            allowsMultipleSelection: false
        ) { result in
            handleFileImport(result)
        }
        .navigationTitle("Import")
    }

    private func handleFileImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }

            // Must access security-scoped resource
            guard url.startAccessingSecurityScopedResource() else {
                importResult = .failure("Permission denied")
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }

            do {
                let csvString = try String(contentsOf: url, encoding: .utf8)
                let athletes = HudlCSVParser.parse(csv: csvString)
                for athlete in athletes {
                    store.addAthlete(athlete)
                }
                importResult = .success(athletes.count)
            } catch {
                importResult = .failure("Failed to read file: \(error.localizedDescription)")
            }

        case .failure(let error):
            importResult = .failure(error.localizedDescription)
        }
    }
}
