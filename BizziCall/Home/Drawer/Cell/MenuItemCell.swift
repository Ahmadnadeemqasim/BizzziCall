//
//  MenuItemCell.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 6/6/24.
//

import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet weak var lblMenuItem: UILabel!
    @IBOutlet weak var imgMenuItem: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
