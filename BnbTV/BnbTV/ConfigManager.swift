import Foundation

@MainActor
class ConfigManager: ObservableObject {
    @Published private(set) var info: HostInfo?
    private let baseURL = URL(string: "https://bnb.paynebrain.com/BxBHostInfo/")!

    private var tvCode: String {
        let defaults = UserDefaults.standard
        if let existing = defaults.string(forKey: "tvCode"), !existing.isEmpty {
            return existing
        }
        let new = Self.generateCode()
        defaults.set(new, forKey: "tvCode")
        return new
    }

    func load() async {
        do {
            let url = baseURL.appendingPathComponent("\(tvCode).json")
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let remote = try decoder.decode(HostInfo.self, from: data)
            apply(info: remote)
        } catch {
            print("Failed to load config: \(error)")
        }
    }

    private func apply(info: HostInfo) {
        self.info = info
        let defaults = UserDefaults.standard
        defaults.set(info.welcomeMessage, forKey: "welcomeMessage")
        defaults.set(info.wifi.name, forKey: "wifiSSID")
        defaults.set(info.wifi.password, forKey: "wifiPassword")

        let rulesText = "Checkout: \(info.rules.checkOutTime)\nSmoking: \(info.rules.smokingPolicy)\nPets: \(info.rules.petRules)\nCleaning: \(info.rules.cleaningExpectations)"
        defaults.set(rulesText, forKey: "houseRules")

        defaults.set(info.local.recommendations, forKey: "localRecommendations")
        defaults.set(info.local.hiddenGems, forKey: "localHiddenGems")
        defaults.set(info.contacts.primary, forKey: "primaryContact")
        defaults.set(info.contacts.emergency, forKey: "emergencyContact")
        defaults.set(info.guides.instructions.map { "\($0.item): \($0.direction)" }.joined(separator: "\n"), forKey: "guides")
    }

    private static func generateCode() -> String {
        let chars = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        return String((0..<6).compactMap { _ in chars.randomElement() })
    }
}
