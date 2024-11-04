//
//  BoardCollectionViewCell.swift
//  soundboard
//
//  Created by Safwan on 26/04/2024.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {

    //MARK: - Identifier
    static var identifier: String {return String(describing: self)}
    static var nib: UINib {return UINib(nibName: identifier, bundle: nil)}
    
    //MARK: @IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(title: String, isSelected: Bool) {
        lblTitle.text = title
        if isSelected {
            viewMain.borderWidth = 5
        } else {
            viewMain.borderWidth = 0
        }
        
    }

}
