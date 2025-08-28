import Foundation

struct WeatherData: Decodable {
    let temperature: Double
    let description: String
}

actor WeatherManager {
    static let shared = WeatherManager()

    func fetchWeather(for zip: String) async throws -> WeatherData {
        let geoURL = URL(string: "https://api.zippopotam.us/us/\(zip)")!
        let (geoData, _) = try await URLSession.shared.data(from: geoURL)
        let geo = try JSONDecoder().decode(GeoResponse.self, from: geoData)
        guard let place = geo.places.first,
              let lat = Double(place.latitude),
              let lon = Double(place.longitude) else {
            throw URLError(.badServerResponse)
        }
        let weatherURL = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true&temperature_unit=fahrenheit")!
        let (weatherData, _) = try await URLSession.shared.data(from: weatherURL)
        let weather = try JSONDecoder().decode(WeatherResponse.self, from: weatherData)
        let desc = description(for: weather.current_weather.weathercode)
        return WeatherData(temperature: weather.current_weather.temperature, description: desc)
    }

    private func description(for code: Int) -> String {
        switch code {
        case 0: return "Clear"
        case 1, 2, 3: return "Clouds"
        case 45, 48: return "Fog"
        case 51, 53, 55: return "Drizzle"
        case 61, 63, 65: return "Rain"
        case 71, 73, 75: return "Snow"
        default: return "Unknown"
        }
    }
}

private struct GeoResponse: Decodable {
    struct Place: Decodable {
        let latitude: String
        let longitude: String
    }
    let places: [Place]
}

private struct WeatherResponse: Decodable {
    struct Current: Decodable {
        let temperature: Double
        let weathercode: Int
    }
    let current_weather: Current
}

