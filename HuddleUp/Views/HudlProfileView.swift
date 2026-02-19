import SwiftUI

struct HudlProfileView: View {
    let athleteName: String

    // Construct a Hudl search URL (or use direct profile link if you have it)
    var hudlURL: URL {
        let query = athleteName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://www.hudl.com/search?query=\(query)")!
    }

    var body: some View {
        WebView(url: hudlURL)
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Hudl Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: hudlURL) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
    }
}
