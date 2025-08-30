import SwiftUI

struct WeatherCardView: View {
    let forecast: [ForecastDay]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(Array(forecast.prefix(3).enumerated()), id: \.offset) { _, day in
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(day.date, format: Date.FormatStyle().weekday(.abbreviated))
                            .font(.headline)
                        Text(day.description)
                            .font(.caption2)
                            .multilineTextAlignment(.leading)
                        Text("High: \(Int(day.high))°F")
                            .font(.caption2)
                        Text("Low: \(Int(day.low))°F")
                            .font(.caption2)
                        Text("Rain: \(Int(day.rainChance))%")
                            .font(.caption2)
                    }
                    .padding()
                }
                .frame(width: 220, height: 220, alignment: .leading)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(25)
            }
        }
    }
}

#Preview {
    WeatherCardView(forecast: [])
}
