//
//  SettingsView.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI
import UIKit

enum BackgroundOption: Identifiable {
    case color(String)
    case image(String)
    case video(String)

    var id: String {
        switch self {
        case .color(let name): return "color:\(name)"
        case .image(let name): return "image:\(name)"
        case .video(let name): return "video:\(name)"
        }
    }

    var tag: String {
        switch self {
        case .color(let name): return "color:\(name)"
        case .image(let name), .video(let name): return name
        }
    }
}

struct SettingsView: View {
    @AppStorage("userName") private var userName: String = "Guest"
    @AppStorage("backgroundMedia") private var backgroundMedia: String = "back1"
    @AppStorage("zipCode") private var zipCode: String = ""

    @State private var showPreview = false

    private let backgrounds: [BackgroundOption] = [
        .color("blue"),
        .color("green"),
        .color("red"),
        .image("TVback"),
        .image("back1"),
        .video("beach.mp4"),
        .video("beach2.mov"),
        .video("beach3.mov")
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
                        case .color(let name):
                            HStack {
                                Circle()
                                    .fill(color(for: name))
                                    .frame(width: 20, height: 20)
                                Text(name.capitalized)
                            }
                            .tag(option.tag)
                        case .image(let name):
                            Image(name)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 80)
                                .clipped()
                                .tag(option.tag)
                        case .video(let name):
                            Label(name, systemImage: "play.rectangle")
                                .tag(option.tag)
                        }
                    }
                }
                .pickerStyle(.menu)

                Button("Preview") { showPreview = true }
                    .sheet(isPresented: $showPreview) {
                        backgroundPreview
                    }
            }

            Section("Zip Code") {
                TextField("Zip Code", text: $zipCode)
                    .keyboardType(.numberPad)
            }
        }
        .navigationTitle("Settings")
    }

    private var backgroundPreview: some View {
        Group {
            if backgroundMedia.hasPrefix("color:") {
                let name = backgroundMedia.replacingOccurrences(of: "color:", with: "")
                color(for: name)
            } else if let url = videoURL(for: backgroundMedia) {
                LoopingVideoView(url: url)
                    .id(backgroundMedia)
            } else if let image = UIImage(named: backgroundMedia) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.blue
            }
        }
        .ignoresSafeArea()
    }

    private func videoURL(for name: String) -> URL? {
        let ext = (name as NSString).pathExtension.lowercased()
        guard ["mp4", "mov"].contains(ext) else { return nil }
        let baseName = (name as NSString).deletingPathExtension
        return Bundle.main.url(forResource: baseName, withExtension: ext)
    }

    private func color(for name: String) -> Color {
        switch name.lowercased() {
        case "red": return .red
        case "green": return .green
        case "blue": return .blue
        default: return .blue
        }
    }
}

#Preview {
    SettingsView()
}
