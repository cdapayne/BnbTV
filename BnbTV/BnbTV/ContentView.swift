//
//  ContentView.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI
import UIKit

/// Represents the buttons shown along the bottom of the home screen.
enum HomeAction: String, CaseIterable, Identifiable {
    case wifi = "WiFi Password"
    case rules = "House Rules"
    case around = "Things Around Here"
    case howTo = "How To"
    case checkout = "Check Out"
    case tvGuide = "TV Guide"
    case localEats = "Local Eats"
    case emergency = "Emergency Contacts"

    var id: String { rawValue }

    /// SF Symbol associated with each action.
    var systemImage: String {
        switch self {
        case .wifi: return "wifi"
        case .rules: return "doc.text"
        case .around: return "map"
        case .howTo: return "questionmark.circle"
        case .checkout: return "door.left.hand.open"
        case .tvGuide: return "tv"
        case .localEats: return "fork.knife"
        case .emergency: return "phone"
        }
    }
}

struct ContentView: View {
    @AppStorage("userName") private var userName: String = "Guest"
    @AppStorage("backgroundImage") private var backgroundImageName: String = ""
    @AppStorage("zipCode") private var zipCode: String = ""

    @State private var weather: WeatherData?
    @State private var currentDate: Date = Date()

    private let actions = HomeAction.allCases
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: currentDate)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                backgroundView
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 40) {
                    Text("Welcome")
                        .font(.system(size: 80, weight: .bold))
                    Text(userName)
                        .font(.system(size: 60, weight: .semibold))

                    Spacer()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 40) {
                            ForEach(actions) { action in
                                Button(action: {}) {
                                    VStack {
                                        Image(systemName: action.systemImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 60)
                                        Text(action.rawValue)
                                    }
                                }
                                .frame(width: 400, height: 120)
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(20)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Text("Swipe to see more")
                        .font(.footnote)
                        .padding(.leading)

                    Spacer().frame(height: 40)
                }
                .padding(.leading, 80)

                VStack(alignment: .trailing, spacing: 4) {
                    Text(timeString)
                        .font(.title3)
                    if let weather = weather {
                        Text("\(weather.description) \(Int(weather.temperature))°F")
                            .font(.footnote)
                    }
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 40))
                    }
                }
                .padding()
            }
            .task {
                await refreshWeather()
            }
            .onChange(of: zipCode) { _ in
                Task { await refreshWeather() }
            }
            .onReceive(timer) { currentDate = $0 }
        }
    }

    private var backgroundView: some View {
        Group {
            if let image = UIImage(named: backgroundImageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Color.blue
            }
        }
    }

    private func refreshWeather() async {
        guard !zipCode.isEmpty else { return }
        weather = try? await WeatherManager.shared.fetchWeather(for: zipCode)
    }
}

#Preview {
    ContentView()
}

