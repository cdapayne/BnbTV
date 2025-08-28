//
//  SettingsView.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = "Guest"
    @AppStorage("backgroundColor") private var backgroundColorName: String = "Blue"

    private let colors = ["Blue", "Green", "Orange", "Gray"]

    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $userName)
            }

            Section("Background") {
                Picker("Background", selection: $backgroundColorName) {
                    ForEach(colors, id: \.self) { color in
                        Text(color)
                    }
                }
                .pickerStyle(.wheel)
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}

