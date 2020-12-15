//
//  GIFsCollectionViewController.swift
//  GIF Search
//
//  Created by Anon on 6/5/20.
//

import UIKit
import AVKit

private let reuseIdentifier = "Cell"

/// Collection View Controller subclass that displays GIFs
class GIFsCollectionViewController: UICollectionViewController {

    // MARK: - instance properties
    /// The backing array for the data source
    var GIFs: [GIF]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionView Data Source/Delegate methodss
    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { GIFs?.count ?? 0 }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GIFCollectionViewCell
    
        let GIF = GIFs![indexPath.row]
        
        configure(cell: cell, with: GIF)
    
        return cell
    }

    // MARK: - private methods
    /// Configures the cells `playerView` property with a player item
    /// - Parameters:
    ///   - cell: the cell
    ///   - GIF: the GIF model object. If an appropriate URL is not available, the reused player view has its player items removed
    private func configure(cell: GIFCollectionViewCell, with GIF: GIF) {
        guard let url = GIF.fixedWidthMP4URL else {
            cell.playerView.queuePlayer?.removeAllItems()
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        cell.playerView.setPlayerItem(playerItem)
    }
}
