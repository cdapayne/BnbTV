import Foundation

struct WeatherData: Decodable {
    let temperature: Double
    let description: String
}

struct ForecastDay: Identifiable {
    let id = UUID()
    let date: Date
    let high: Double
    let low: Double
    let description: String
    let rainChance: Double
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

    func fetchForecast(for zip: String) async throws -> [ForecastDay] {
        let geoURL = URL(string: "https://api.zippopotam.us/us/\(zip)")!
        let (geoData, _) = try await URLSession.shared.data(from: geoURL)
        let geo = try JSONDecoder().decode(GeoResponse.self, from: geoData)
        guard let place = geo.places.first,
              let lat = Double(place.latitude),
              let lon = Double(place.longitude) else {
            throw URLError(.badServerResponse)
        }
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_max&temperature_unit=fahrenheit&forecast_days=3")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let forecast = try JSONDecoder().decode(ForecastResponse.self, from: data)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return forecast.daily.time.indices.map { index in
            ForecastDay(
                date: formatter.date(from: forecast.daily.time[index]) ?? Date(),
                high: forecast.daily.temperature_2m_max[index],
                low: forecast.daily.temperature_2m_min[index],
                description: description(for: forecast.daily.weathercode[index]),
                rainChance: forecast.daily.precipitation_probability_max[index]
            )
        }
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

private struct ForecastResponse: Decodable {
    struct Daily: Decodable {
        let time: [String]
        let weathercode: [Int]
        let temperature_2m_max: [Double]
        let temperature_2m_min: [Double]
        let precipitation_probability_max: [Double]
    }
    let daily: Daily
}

