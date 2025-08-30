import SwiftUI

struct WeatherCardView: View {
    let forecast: [ForecastDay]
    @State private var index: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(forecast.prefix(3).enumerated()), id: \.offset) { i, day in
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
                        .font(.system(size: 40, weight: .bold))
                        .padding(8)
                }
                .frame(width: 450, height: 220, alignment: .leading)
                .background(Color.blue.opacity(0.5))
                .cornerRadius(25)
                .tag(i)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(width: 450, height: 220)
        .onReceive(timer) { _ in
            guard !forecast.isEmpty else { return }
            withAnimation {
                index = (index + 1) % min(forecast.count, 3)
            }
        }
    }
}

#Preview {
    WeatherCardView(forecast: [])
}
