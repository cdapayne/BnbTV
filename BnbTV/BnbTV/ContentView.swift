//
//  ContentView.swift
//  BnbTV
//
//  Created by PayneBrain on 8/27/25.
//

import SwiftUI
import UIKit
import AVKit
import AVFoundation

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
    @AppStorage("backgroundMedia") private var backgroundMediaName: String = ""
    @AppStorage("zipCode") private var zipCode: String = ""
    @AppStorage("homeMusic") private var homeMusicName: String = ""
    @AppStorage("buttonColor") private var buttonColorName: String = "transparentGrey"
    @EnvironmentObject private var configManager: ConfigManager

    @State private var weather: WeatherData?
    @State private var currentDate: Date = Date()
    @State private var audioPlayer: AVAudioPlayer?
    @Environment(\.scenePhase) private var scenePhase
    @FocusState private var focusedAction: HomeAction?

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
                    if let welcome = configManager.screen(ofType: .welcome) {
                        Text(welcome.title)
                            .font(.system(size: 80, weight: .bold))
                        Text(userName)
                            .font(.system(size: 60, weight: .semibold))
                        if let body = welcome.body {
                            Text(body)
                                .font(.title2)
                        }
                    } else {
                        Text("Welcome")
                            .font(.system(size: 80, weight: .bold))
                        Text(userName)
                            .font(.system(size: 60, weight: .semibold))
                    }

                    Spacer()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 40) {
                            ForEach(actions) { action in
                                NavigationLink(destination: destinationView(for: action)) {
                                    VStack {
                                        Image(systemName: action.systemImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: focusedAction == action ? 80 : 60)
                                        Text(action.rawValue)
                                    }
                                }
                                .focused($focusedAction, equals: action)
                                .buttonStyle(HomeButtonStyle(color: color(for: buttonColorName)))
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
                    NavigationLink(destination: SettingsView(onDismiss: { playMusic() })) {
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
            .onAppear { playMusic() }
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    playMusic()
                } else {
                    audioPlayer?.stop()
                }
            }
        }
    }

    private var backgroundView: some View {
           Group {
               if backgroundMediaName.hasPrefix("color:") {
                   let name = backgroundMediaName.replacingOccurrences(of: "color:", with: "")
                   color(for: name)
               } else if let url = videoURL(for: backgroundMediaName) {
                   LoopingVideoView(url: url)
                       .id(backgroundMediaName)
               } else if let image = UIImage(named: backgroundMediaName) {
                   Image(uiImage: image)
                       .resizable()
                       .scaledToFill()
               } else {
                   Color.blue
               }
           }
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

    @ViewBuilder
    private func destinationView(for action: HomeAction) -> some View {
        switch action {
        case .rules:
            if let screen = configManager.screen(ofType: .rules) {
                ScreenView(screen: screen)
            } else {
                HouseRulesView()
            }
        case .wifi:
            if let screen = configManager.screen(ofType: .wifi) {
                ScreenView(screen: screen)
            } else {
                PlaceholderView(title: action.rawValue)
            }
        case .howTo:
            if let screen = configManager.screen(ofType: .howto) {
                ScreenView(screen: screen)
            } else {
                PlaceholderView(title: action.rawValue)
            }
        case .checkout:
            if let screen = configManager.screen(ofType: .checkout) {
                ScreenView(screen: screen)
            } else {
                PlaceholderView(title: action.rawValue)
            }
        case .emergency:
            if let screen = configManager.screen(ofType: .contacts) {
                ScreenView(screen: screen)
            } else {
                PlaceholderView(title: action.rawValue)
            }
        default:
            PlaceholderView(title: action.rawValue)
        }
    }

    private struct HomeButtonStyle: ButtonStyle {
        let color: Color
        @Environment(\.isFocused) private var isFocused: Bool
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width: 400, height: 220)
                .background(color)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: isFocused ? 4 : 0)
                )
                .overlay(Color.gray.opacity(configuration.isPressed ? 0.4 : 0))
                .cornerRadius(20)
        }
    }

    private func playMusic() {
        audioPlayer?.stop()
        guard !homeMusicName.isEmpty else { return }
        let base = (homeMusicName as NSString).deletingPathExtension
        let ext = (homeMusicName as NSString).pathExtension
        guard let url = Bundle.main.url(forResource: base, withExtension: ext) else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.play()
    }

    private func refreshWeather() async {
        guard !zipCode.isEmpty else { return }
        weather = try? await WeatherManager.shared.fetchWeather(for: zipCode)
    }
}

#Preview {
    ContentView()
}

