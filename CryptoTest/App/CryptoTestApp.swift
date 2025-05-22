import SwiftUI

@main
struct CryptoTestApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
