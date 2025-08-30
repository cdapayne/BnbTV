import SwiftUI

struct InfoView: View {
    let title: String
    let content: String

    var body: some View {
        ScrollView {
            Text(content)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .navigationTitle(title)
    }
}

#Preview {
    InfoView(title: "Title", content: "Sample content")
}
