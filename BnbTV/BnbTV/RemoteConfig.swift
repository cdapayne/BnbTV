import Foundation

struct RemoteConfig: Decodable {
    struct Guest: Decodable {
        let displayName: String
    }

    struct Stay: Decodable {
        let checkIn: String
        let checkOut: String
        let propertyName: String
    }

    struct Wifi: Decodable {
        let ssid: String
        let password: String
    }

    struct Theme: Decodable {
        let accent: String
        let backgroundImage: String
    }

    struct Screen: Decodable, Identifiable {
        enum ScreenType: String, Decodable {
            case welcome
            case wifi
            case rules
            case howto
            case checkout
            case contacts
        }

        let id = UUID()
        let type: ScreenType
        let title: String
        let body: String?
        let items: [String]?
    }

    let version: Int
    let validUntil: Date
    let locale: String
    let guest: Guest
    let stay: Stay
    let wifi: Wifi
    let theme: Theme
    let screens: [Screen]
}
