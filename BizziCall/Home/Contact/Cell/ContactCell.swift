//
//  ContactCell.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 6/2/24.
//

import UIKit

protocol statusGestureProtocol {
    func statusTapped(_ sender: Any)
}
class ContactCell: UITableViewCell {

    @IBOutlet weak var lblCallerName: UILabel!
    @IBOutlet weak var lblCallerNumber: UILabel!
    @IBOutlet weak var vwCallstatus: UIView!
    var delegate: statusGestureProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestures()
        vwCallstatus.layer.cornerRadius = vwCallstatus.frame.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupGestures() {
        let vwStatusGesture = UITapGestureRecognizer(target: self, action: #selector(statusTapped))
        vwCallstatus?.addGestureRecognizer(vwStatusGesture)
        vwCallstatus?.isUserInteractionEnabled = true
        
    }
    
    @objc func statusTapped(_ sender: Any) {
        print("status tapped")
        if delegate != nil {
            delegate.statusTapped(sender)
        }
        
        
    }
    
}
