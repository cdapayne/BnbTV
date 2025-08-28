import SwiftUI

struct AdminPanel: View {
    @ObservedObject var viewModel: AppViewModel
    @Binding var isPresented: Bool

    @State private var urlText: String
    @State private var interval: Double
    @State private var locale: String

    init(viewModel: AppViewModel, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self._isPresented = isPresented
        self._urlText = State(initialValue: viewModel.contentURL.absoluteString)
        self._interval = State(initialValue: viewModel.cycleInterval)
        self._locale = State(initialValue: viewModel.currentLocale)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Admin Controls").font(.title)
            TextField("Guest Pack URL", text: $urlText)
                .textFieldStyle(.roundedBorder)
            HStack {
                Button("Update URL") { viewModel.load(from: urlText) }
                Button("Refresh") { viewModel.refresh() }
            }
            Picker("Cycle Interval", selection: $interval) {
                ForEach([10.0, 20.0, 30.0], id: \.self) { seconds in
                    Text("\(Int(seconds))s").tag(seconds)
                }
            }
            .onChange(of: interval) { viewModel.cycleInterval = interval }
            Picker("Language", selection: $locale) {
                ForEach(viewModel.availableLocales, id: \.self) { code in
                    Text(code.uppercased()).tag(code)
                }
            }
            .onChange(of: locale) { newValue in
                viewModel.currentLocale = newValue
                viewModel.refresh()
            }
            Button("Close") { isPresented = false }
        }
        .padding()
        .frame(maxWidth: 600)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}
