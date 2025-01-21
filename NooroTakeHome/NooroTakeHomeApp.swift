import SwiftUI

@main
struct NooroTakeHomeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: HomeViewModel())
        }
    }
}
