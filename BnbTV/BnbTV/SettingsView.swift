//
//  SettingsView.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = "Guest"
    @AppStorage("backgroundImage") private var backgroundImageName: String = ""
    @AppStorage("zipCode") private var zipCode: String = ""

    private let imageOptions: [String] = {
        let urls = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: "photos") ?? []
        return urls.map { $0.deletingPathExtension().lastPathComponent }
    }()

    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $userName)
            }

            Section("Background") {
                Picker("Background", selection: $backgroundImageName) {
                    ForEach(imageOptions, id: \.self) { name in
                        Text(name)
                    }
                }
                .pickerStyle(.wheel)
            }

            Section("Weather") {
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

