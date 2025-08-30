import SwiftUI

struct ThemeParkView: View {
    enum City: String, CaseIterable, Identifiable {
        case orlando = "Orlando"
        case la = "LA"
        var id: String { rawValue }
    }

    struct ParkInfo: Identifiable {
        let id = UUID()
        let name: String
        let hours: String
    }

    @State private var selectedCity: City? = nil

    var body: some View {
        VStack {
            Picker("City", selection: $selectedCity) {
                Text("Orlando").tag(City.orlando as City?)
                Text("LA").tag(City.la as City?)
            }
            .pickerStyle(.segmented)
            .padding()

            if let city = selectedCity {
                List(parkHours(for: city)) { park in
                    VStack(alignment: .leading) {
                        Text(park.name)
                            .font(.headline)
                        Text(park.hours)
                    }
                }
            } else {
                Text("Select a city to view park hours.")
                    .padding()
            }
        }
        .navigationTitle("Theme Parks")
    }

    private func parkHours(for city: City) -> [ParkInfo] {
        switch city {
        case .orlando:
            return [
                ParkInfo(name: "Magic Kingdom", hours: "9am - 10pm"),
                ParkInfo(name: "Epcot", hours: "9am - 9pm"),
                ParkInfo(name: "Disney's Animal Kingdom", hours: "8am - 7pm"),
                ParkInfo(name: "Universal Studios Florida", hours: "9am - 8pm"),
                ParkInfo(name: "Islands of Adventure", hours: "9am - 8pm")
            ]
        case .la:
            return [
                ParkInfo(name: "Disneyland", hours: "8am - 12am"),
                ParkInfo(name: "California Adventure", hours: "8am - 10pm"),
                ParkInfo(name: "Universal Studios Hollywood", hours: "9am - 7pm")
            ]
        }
    }
}

#Preview {
    ThemeParkView()
}
