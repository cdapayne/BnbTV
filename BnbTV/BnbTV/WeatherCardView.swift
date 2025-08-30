import SwiftUI

struct WeatherCardView: View {
    let forecast: [ForecastDay]
    @State private var index: Int = 0
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $index) {
            ForEach(Array(forecast.prefix(3).enumerated()), id: \.offset) { i, day in
                VStack(alignment: .leading, spacing: 8) {
                    Text(day.date, format: Date.FormatStyle().weekday(.abbreviated))
                        .font(.headline)
                    Text(day.description)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    Text("High: \(Int(day.high))°F")
                    Text("Low: \(Int(day.low))°F")
                    Text("Rain: \(Int(day.rainChance))%")
                }
                .padding()
                .frame(width: 450, height: 220, alignment: .leading)
                .background(Color.white.opacity(0.3))
                .cornerRadius(10)
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
