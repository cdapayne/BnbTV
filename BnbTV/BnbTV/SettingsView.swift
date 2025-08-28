//
//  SettingsView.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = "Guest"
    @AppStorage("backgroundImage") private var backgroundImage: String = "back1"
    @AppStorage("zipCode") private var zipCode: String = ""

    private let backgrounds = ["TVback", "back1", "back1"]

    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $userName)
            }

            Section("Background") {
                Picker("Background", selection: $backgroundImage) {
                    ForEach(backgrounds, id: \.self) { bg in
                        Image(bg)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 80)
                            .clipped()
                            .tag(bg)
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
