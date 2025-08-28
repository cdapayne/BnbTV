import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @State private var currentIndex: Int = 0
    @State private var showAdmin = false
    @State private var timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            if let config = viewModel.config, !viewModel.screens.isEmpty {
                ScreenView(screen: viewModel.screens[currentIndex], config: config)
            } else {
                ProgressView("Loading...")
            }
            if showAdmin {
                AdminPanel(viewModel: viewModel, isPresented: $showAdmin)
            }
        }
        .onAppear { viewModel.load(from: viewModel.contentURL.absoluteString) }
        .onReceive(timer) { _ in nextScreen() }
        .onChange(of: viewModel.cycleInterval) { newVal in
            timer = Timer.publish(every: newVal, on: .main, in: .common).autoconnect()
        }
        .onMoveCommand { direction in
            switch direction {
            case .left: previousScreen()
            case .right: nextScreen()
            default: break
            }
        }
        .onPlayPauseCommand { showAdmin.toggle() }
    }

    private func nextScreen() {
        guard !viewModel.screens.isEmpty else { return }
        currentIndex = (currentIndex + 1) % viewModel.screens.count
    }

    private func previousScreen() {
        guard !viewModel.screens.isEmpty else { return }
        currentIndex = (currentIndex - 1 + viewModel.screens.count) % viewModel.screens.count
    }
}

#Preview {
    ContentView()
}
