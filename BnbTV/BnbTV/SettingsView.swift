//
//  SettingsView.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI

enum BackgroundOption: Identifiable {
    case image(String)
    case video(String)

    var id: String {
        switch self {
        case .image(let name), .video(let name):
            return name
        }
    }
}

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = "Guest"
    @AppStorage("backgroundMedia") private var backgroundMedia: String = "back1"
    @AppStorage("zipCode") private var zipCode: String = ""

    private let backgrounds: [BackgroundOption] = [
        .image("TVback"),
        .image("back1"),
        .video("beach.mp4")
    ]

    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $userName)
            }

            Section("Background") {
                Picker("Background", selection: $backgroundMedia) {
                    ForEach(backgrounds) { option in
                        switch option {
                        case .image(let name):
                            Image(name)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 80)
                                .clipped()
                                .tag(name)
                        case .video(let name):
                            Label(name, systemImage: "play.rectangle")
                                .tag(name)
                        }
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Zip Code") {
                TextField("Zip Code", text: $zipCode)
                    .keyboardType(.numberPad)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
