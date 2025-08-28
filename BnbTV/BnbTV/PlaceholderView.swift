import SwiftUI

struct PlaceholderView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.largeTitle)
            .padding()
    }
}

#Preview {
    PlaceholderView(title: "Placeholder")
}
