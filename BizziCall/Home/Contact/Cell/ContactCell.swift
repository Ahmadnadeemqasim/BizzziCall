//
//  ContactCell.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 6/2/24.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var lblCallerName: UILabel!
    @IBOutlet weak var lblCallerNumber: UILabel!
    @IBOutlet weak var vwCallstatus: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwCallstatus.layer.cornerRadius = vwCallstatus.frame.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
