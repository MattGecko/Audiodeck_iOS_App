//
//  TrackCollectionViewCell.swift
//  soundboard
//
//  Created by Safwan on 26/04/2024.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {

    //MARK: - Identifier
    static var identifier: String {return String(describing: self)}
    static var nib: UINib {return UINib(nibName: identifier, bundle: nil)}
    
    //MARK: @IBOutlets
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var imgPlaying: UIImageView!
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var imgLoop: UIImageView!
    @IBOutlet weak var lblDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(track: Track, isPlaying: Bool) {
        lblTrackName.text = track.title
        imgPlaying.isHidden = !isPlaying
        lblVolume.text = track.volume.toPercentageString(fractionDigits: 0)
        imgLoop.isHidden = !track.loop
        lblDuration.text = track.duration.secondsToTimeString()
    }

}
