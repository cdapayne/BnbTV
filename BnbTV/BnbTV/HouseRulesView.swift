import SwiftUI

struct HouseRulesView: View {
    @AppStorage("houseRules") private var houseRules: String = ""

    var body: some View {
        ScrollView {
            Text(houseRules.isEmpty ? "No house rules set." : houseRules)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        .navigationTitle("House Rules")
    }
}

#Preview {
    HouseRulesView()
}
