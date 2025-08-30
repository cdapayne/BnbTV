import SwiftUI

struct WeatherCardView: View {
    let forecast: [ForecastDay]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(Array(forecast.prefix(3).enumerated()), id: \.offset) { _, day in
                ZStack(alignment: .topTrailing) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(day.date, format: Date.FormatStyle().weekday(.abbreviated))
                            .font(.headline)
                        Text(weatherEmoji(for: day.description))
                            .font(.largeTitle)
                        Text(day.description)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Text("High: \(Int(day.high))°F")
                        Text("Low: \(Int(day.low))°F")
                        Text("Rain: \(Int(day.rainChance))%")
                    }
                    .padding()
                    Text(day.date, format: Date.FormatStyle().day())
                        .font(.system(size: 24, weight: .bold))
                        .padding(8)
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
