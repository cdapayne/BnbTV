import SwiftUI
import AVKit

/// A looping video view that hides playback controls and does not steal focus.
struct LoopingVideoView: View {
    let url: URL

    var body: some View {
        GeometryReader { proxy in
            PlayerControllerView(url: url)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .allowsHitTesting(false)
#if os(tvOS)
                .focusable(false)
#endif
        }
    }
}

private struct PlayerControllerView: UIViewControllerRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.view.isUserInteractionEnabled = false
        controller.videoGravity = .resizeAspectFill

        let player = context.coordinator.player
        controller.player = player

        let item = AVPlayerItem(url: url)
        context.coordinator.looper = AVPlayerLooper(player: player, templateItem: item)
        player.play()

        return controller
    }

    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        let player = context.coordinator.player
        // Check if the current item URL differs from the new URL. If so, stop
        // the existing video before loading and playing the new one.
        if let currentAsset = player.currentItem?.asset as? AVURLAsset,
           currentAsset.url != url {
            player.pause()
            let item = AVPlayerItem(url: url)
            context.coordinator.looper = AVPlayerLooper(player: player, templateItem: item)
            player.play()
        }
    }

    class Coordinator {
        let player = AVQueuePlayer()
        var looper: AVPlayerLooper?
    }
}
