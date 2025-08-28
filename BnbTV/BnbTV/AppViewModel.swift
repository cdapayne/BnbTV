import Foundation
import SwiftUI

@MainActor
class AppViewModel: ObservableObject {
    @Published var config: AppConfig?
    @Published var screens: [Screen] = []
    @Published var cycleInterval: Double = 10
    @Published var availableLocales: [String] = ["en"]
    @Published var currentLocale: String = "en"

    var contentURL: URL = URL(string: "https://example.com/guest.json")!

    func load(from urlString: String? = nil) {
        if let urlString = urlString, let url = URL(string: urlString) {
            contentURL = url
        }
        refresh()
    }

    func refresh() {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: contentURL)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let cfg = try decoder.decode(AppConfig.self, from: data)
                config = cfg
                screens = cfg.screens
                currentLocale = cfg.locale
                availableLocales = [cfg.locale]
            } catch {
                print("Failed to fetch config: \(error)")
            }
        }
    }
}
