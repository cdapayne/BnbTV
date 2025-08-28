import Foundation
import SwiftUI

struct AppConfig: Decodable {
    struct Guest: Decodable { let displayName: String }
    struct Stay: Decodable { let checkIn: String; let checkOut: String; let propertyName: String }
    struct WiFi: Decodable { let ssid: String; let password: String }
    struct Theme: Decodable { let accent: String?; let backgroundImage: String? }

    let version: Int
    let validUntil: Date
    let locale: String
    let guest: Guest
    let stay: Stay
    let wifi: WiFi
    let theme: Theme?
    let screens: [Screen]
}

enum ScreenType: String, Decodable {
    case welcome, wifi, rules, howto, checkout, contacts, tips
}

struct Screen: Decodable, Identifiable {
    let id = UUID()
    let type: ScreenType
    let title: String
    let body: String?
    let items: [String]?
    let tips: [Tip]?
}

struct Tip: Decodable, Identifiable {
    let id = UUID()
    let name: String
    let blurb: String
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
