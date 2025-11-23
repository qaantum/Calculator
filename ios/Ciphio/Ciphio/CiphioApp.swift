import SwiftUI

@main
struct CiphioApp: App {
    @StateObject private var historyStore = HistoryStore()

    var body: some Scene {
        WindowGroup {
            AppContentView(historyStore: historyStore)
        }
    }
}

private struct AppContentView: View {
    @StateObject private var viewModel: HomeViewModel
    let historyStore: HistoryStore
    
    init(historyStore: HistoryStore) {
        self.historyStore = historyStore
        _viewModel = StateObject(wrappedValue: HomeViewModel(
            cryptoService: CryptoService(),
            passwordGenerator: PasswordGenerator(),
            historyStore: historyStore
        ))
    }
    
    var body: some View {
        ContentView(viewModel: viewModel)
            .onOpenURL { url in
                viewModel.handleDeepLink(url: url)
            }
    }
}
