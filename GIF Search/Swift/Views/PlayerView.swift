//
//  PlayerView.swift
//  GIF Search
//
//  Created by Anon on 6/5/20.
//

import UIKit
import AVKit

/// View with an `AVPlayerLayer` backing layer, configured with a looping `AVQueuePlayer`
class PlayerView: UIView {
    // MARK: - private properties
    // the `AVPlayerLooper` instance needs to be retained, rather than retaining it in the Collection View Controller subclass it is retained here for simplicity
    private var playerLooper: AVPlayerLooper?
    
    /// Backing layer
    private var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    // MARK: - instance properties
    /// The queue player that is the player of the `AVPlayerLayer`'s content
    var queuePlayer: AVQueuePlayer? {
        get {
            return playerLayer.player as? AVQueuePlayer
        }
    }
    
    // MARK: - instance methods
    /// Configures the `playerLayer` with an `AVQueuePlayer` that loops the `AVPlayerItem` instance
    /// - Parameter item: the player item
    func setPlayerItem(_ item: AVPlayerItem) {
        let queuePlayer = AVQueuePlayer()
        queuePlayer.play()
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: item)
        playerLayer.player = queuePlayer
    }
    
    // MARK: - Class methods
    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
