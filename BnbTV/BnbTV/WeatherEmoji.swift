import Foundation

func weatherEmoji(for description: String) -> String {
    switch description {
    case "Clear": return "☀️"
    case "Clouds": return "☁️"
    case "Fog": return "🌫️"
    case "Drizzle": return "🌦️"
    case "Rain": return "🌧️"
    case "Snow": return "❄️"
    default: return "❓"
    }
}

