//
//  NotificationCell.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 6/2/24.
//

import UIKit

class NotificationCell: UICollectionViewCell {
    @IBOutlet weak var imgSocialAppIcon: UIImageView!
    @IBOutlet weak var vwBadge: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        vwBadge.layer.cornerRadius = vwBadge.frame.height/2
       
    }

}
