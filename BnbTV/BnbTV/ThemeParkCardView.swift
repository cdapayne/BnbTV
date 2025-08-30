import SwiftUI

struct ThemeParkCardView: View {
    var body: some View {
        NavigationLink(destination: ThemeParkView()) {
            ZStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Theme Parks")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "theatermasks")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                    Spacer()
                }
                .padding()
            }
            .frame(width: 220, height: 220, alignment: .leading)
            .background(Color.green.opacity(0.5))
            .cornerRadius(25)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ThemeParkCardView()
}
