//
//  HistoryCell.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 6/3/24.
//

import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var lblCallTime: UILabel!
    @IBOutlet weak var lblMessageTime: UILabel!
    @IBOutlet weak var lblCallerNumber: UILabel!
    @IBOutlet weak var lblCallerName: UILabel!
    @IBOutlet weak var lblCallerMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
