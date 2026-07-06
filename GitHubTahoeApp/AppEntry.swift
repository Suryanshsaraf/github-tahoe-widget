import SwiftUI

@main
struct GitHubTahoeApp: App {
    var body: some Scene {
        Window("GitHub Tahoe Settings", id: "settings") {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
