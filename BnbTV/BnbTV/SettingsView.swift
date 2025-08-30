//
//  SettingsView.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI
import UIKit
import AVFoundation
import CoreImage.CIFilterBuiltins

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
    var onDismiss: (() -> Void)? = nil
    @AppStorage("userName") private var userName: String = "Guest"
    @AppStorage("backgroundMedia") private var backgroundMedia: String = "back1"
    @AppStorage("zipCode") private var zipCode: String = ""
    @AppStorage("homeMusic") private var homeMusic: String = ""
    @AppStorage("buttonColor") private var buttonColor: String = "transparentGrey"
    @AppStorage("houseRules") private var houseRules: String = ""
    @AppStorage("tvCode") private var tvCode: String = ""
    @AppStorage("isPasscodeEnabled") private var isPasscodeEnabled: Bool = false
    @AppStorage("settingsPasscode") private var settingsPasscode: String = ""

    @State private var showPreview = false
    @State private var musicPlayer: AVAudioPlayer?

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

    private var musicFiles: [String] {
        Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)?
            .map { $0.lastPathComponent }
            .sorted() ?? []
    }
    private let buttonColors = ["white", "green", "black", "transparentGrey", "blue", "red"]

    var body: some View {
        Form {
            Section {
                VStack(spacing: 12) {
                    Text(tvCode)
                        .font(.largeTitle)
                    Text("Scan the QR code below to update your BnB Host TV rules.")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                    Image(uiImage: generateQRCode(from: "https://bnb.paynebrain.com/BxBHostInfo/\(tvCode).json"))
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

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

            Section("Home Music") {
                Picker("Music", selection: $homeMusic) {
                    Text("None").tag("")
                    ForEach(musicFiles, id: \.self) { file in
                        Text(file.replacingOccurrences(of: ".mp3", with: "").capitalized).tag(file)
                    }
                }
                Button("Preview") { previewMusic() }
                    .disabled(homeMusic.isEmpty)
            }

            Section("Button Color") {
                Picker("Button Color", selection: $buttonColor) {
                    ForEach(buttonColors, id: \.self) { color in
                        Text(displayName(for: color)).tag(color)
                    }
                }
            }

            Section("House Rules") {
#if os(tvOS)
                TextField("House Rules", text: $houseRules)
                    .frame(height: 150)
#else
                TextEditor(text: $houseRules)
                    .frame(height: 150)
#endif
            }

            Section("Zip Code") {
                TextField("Zip Code", text: $zipCode)
                    .keyboardType(.numberPad)
            }

            Section("Security") {
                Toggle("Require Passcode", isOn: $isPasscodeEnabled)
                if isPasscodeEnabled {
                    SecureField("Passcode", text: $settingsPasscode)
                }
            }
            .onChange(of: isPasscodeEnabled) { enabled in
                if !enabled { settingsPasscode = "" }
            }
        }
        .navigationTitle("Settings")
        .onDisappear { onDismiss?() }
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
        case "white": return .white
        case "black": return .black
        case "transparentgrey": return Color.gray.opacity(0.3)
        default: return .blue
        }
    }

    private func previewMusic() {
        guard !homeMusic.isEmpty else { return }
        let base = (homeMusic as NSString).deletingPathExtension
        let ext = (homeMusic as NSString).pathExtension
        guard let url = Bundle.main.url(forResource: base, withExtension: ext) else { return }
        musicPlayer = try? AVAudioPlayer(contentsOf: url)
        musicPlayer?.play()
    }

    private func displayName(for color: String) -> String {
        switch color {
        case "transparentGrey": return "Transparent Grey"
        default: return color.capitalized
        }
    }

    private func generateQRCode(from string: String) -> UIImage {
        let data = string.data(using: .ascii)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        if let output = filter.outputImage?.transformed(by: transform) {
            return UIImage(ciImage: output)
        }
        return UIImage()
    }
}

#Preview {
    SettingsView()
}
