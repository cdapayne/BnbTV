import SwiftUI

struct ScreenView: View {
    let screen: RemoteConfig.Screen
    @AppStorage("wifiSSID") private var wifiSSID: String = ""
    @AppStorage("wifiPassword") private var wifiPassword: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if screen.type == .wifi {
                    Text("SSID: \(wifiSSID)")
                    Text("Password: \(wifiPassword)")
                }

                if let body = screen.body {
                    Text(body)
                }

                if let items = screen.items {
                    ForEach(items, id: \.self) { item in
                        Text("• \(item)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(screen.title)
    }
}

#Preview {
    ScreenView(screen: RemoteConfig.Screen(type: .wifi, title: "Wi-Fi", body: "Sample", items: nil))
}
