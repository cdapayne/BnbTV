import SwiftUI

struct ScreenView: View {
    let screen: Screen
    let config: AppConfig

    var body: some View {
        ZStack {
            if let bg = config.theme?.backgroundImage, screen.type == .welcome {
                AsyncImage(url: URL(string: bg)) { image in
                    image.resizable().scaledToFill().ignoresSafeArea()
                } placeholder: {
                    Color.black.ignoresSafeArea()
                }
            } else {
                Color.black.ignoresSafeArea()
            }
            content
                .padding()
                .foregroundColor(.white)
        }
    }

    @ViewBuilder var content: some View {
        switch screen.type {
        case .welcome:
            VStack(spacing: 20) {
                Text(screen.title).font(.largeTitle)
                Text("\(config.guest.displayName)")
                Text("\(config.stay.propertyName)")
                Text("\(config.stay.checkIn) – \(config.stay.checkOut)")
            }
        case .wifi:
            VStack(spacing: 20) {
                Text(screen.title).font(.largeTitle)
                Text("SSID: \(config.wifi.ssid)")
                Text("Password: \(config.wifi.password)")
                QRCodeView(text: "WIFI:T:WPA;S:\(config.wifi.ssid);P:\(config.wifi.password);;")
            }
        case .rules, .checkout:
            VStack(alignment: .leading, spacing: 10) {
                Text(screen.title).font(.largeTitle)
                ForEach(screen.items ?? [], id: \.self) { item in
                    Text("• \(item)")
                }
            }
        case .howto, .contacts:
            VStack(spacing: 20) {
                Text(screen.title).font(.largeTitle)
                if let body = screen.body { Text(body) }
            }
        case .tips:
            VStack(alignment: .leading, spacing: 10) {
                Text(screen.title).font(.largeTitle)
                ForEach(screen.tips ?? []) { tip in
                    VStack(alignment: .leading) {
                        Text(tip.name).font(.headline)
                        Text(tip.blurb)
                    }
                }
            }
        }
    }
}
