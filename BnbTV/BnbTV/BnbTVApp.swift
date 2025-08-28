//
//  BnbTVApp.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI

@main
struct BnbTVApp: App {
    @StateObject private var configManager = ConfigManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(configManager)
                .task {
                    await configManager.load()
                }
        }
    }
}
