//
//  ContentView.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI

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
}

/// Maps a stored background name to a concrete `Color` value.
private func colorFromName(_ name: String) -> Color {
    switch name {
    case "Green":
        return .green
    case "Orange":
        return .orange
    case "Gray":
        return .gray
    default:
        return .blue
    }
}

struct ContentView: View {
    @AppStorage("userName") private var userName: String = "Guest"
    @AppStorage("backgroundColor") private var backgroundColorName: String = "Blue"

    private let actions = HomeAction.allCases

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                colorFromName(backgroundColorName)
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
                                Button(action.rawValue) {}
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

                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 40))
                        .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

