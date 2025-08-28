import Foundation

@MainActor
class ConfigManager: ObservableObject {
    @Published private(set) var config: RemoteConfig?
    private let configURL = URL(string: "https://www.paynebrain.com/appletvconfig.json")!

    func load() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: configURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let remote = try decoder.decode(RemoteConfig.self, from: data)
            apply(config: remote)
        } catch {
            print("Failed to load config: \(error)")
        }
    }

    func screen(ofType type: RemoteConfig.Screen.ScreenType) -> RemoteConfig.Screen? {
        return config?.screens.first { $0.type == type }
    }

    private func apply(config: RemoteConfig) {
        self.config = config
        let defaults = UserDefaults.standard
        defaults.set(config.guest.displayName, forKey: "userName")

        if let rules = screen(ofType: .rules) {
            if let items = rules.items {
                defaults.set(items.joined(separator: "\n"), forKey: "houseRules")
            } else if let body = rules.body {
                defaults.set(body, forKey: "houseRules")
            }
        }

        defaults.set(config.wifi.ssid, forKey: "wifiSSID")
        defaults.set(config.wifi.password, forKey: "wifiPassword")
    }
}
