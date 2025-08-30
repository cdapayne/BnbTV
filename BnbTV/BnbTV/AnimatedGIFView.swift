import SwiftUI
import ImageIO
import UIKit

struct AnimatedGIFView: View {
    let url: URL

    var body: some View {
        GeometryReader { proxy in
            GIFImageView(url: url)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .allowsHitTesting(false)
#if os(tvOS)
                .focusable(false)
#endif
        }
    }
}

private struct GIFImageView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = animatedImage()
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = animatedImage()
    }

    private func animatedImage() -> UIImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let count = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        var duration: TimeInterval = 0
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
                let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [CFString: Any]
                let gifDict = properties?[kCGImagePropertyGIFDictionary] as? [CFString: Any]
                let frameDuration = gifDict?[kCGImagePropertyGIFUnclampedDelayTime] as? NSNumber ?? gifDict?[kCGImagePropertyGIFDelayTime] as? NSNumber ?? 0.1
                duration += frameDuration.doubleValue
            }
        }
        return UIImage.animatedImage(with: images, duration: duration)
    }
}
