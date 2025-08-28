import SwiftUI
import AVKit

struct LoopingVideoView: View {
    let url: URL
    @State private var player = AVQueuePlayer()
    @State private var looper: AVPlayerLooper?

    var body: some View {
        VideoPlayer(player: player)
            .aspectRatio(contentMode: .fill)
            .onAppear {
                let item = AVPlayerItem(url: url)
                looper = AVPlayerLooper(player: player, templateItem: item)
                player.play()
            }
    }
}
