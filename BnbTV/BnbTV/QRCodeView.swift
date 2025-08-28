import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let text: String
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        if let image = generateQRCode(from: text) {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .frame(width: 200, height: 200)
        } else {
            Color.gray.frame(width: 200, height: 200)
        }
    }

    func generateQRCode(from string: String) -> UIImage? {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let output = filter.outputImage {
            let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            if let cgImage = context.createCGImage(scaled, from: scaled.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
