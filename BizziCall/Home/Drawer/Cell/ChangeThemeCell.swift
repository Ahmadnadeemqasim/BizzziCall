//
//  ChangeThemeCell.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 6/9/24.
//

import UIKit

protocol swithcControlDelegate {
    func switchTapped(_ sender: Any)
}

class ChangeThemeCell: UITableViewCell {
    @IBOutlet weak var lblMenuItem: UILabel!
    @IBOutlet weak var imgMenuItem: UIImageView!
    @IBOutlet weak var lblTheme: UILabel!
    @IBOutlet weak var scTheme: UISwitch!
    var delegate: swithcControlDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scTheme.layer.borderWidth = 1
        scTheme.layer.cornerRadius = 14.0
        scTheme.layer.cornerCurve = .continuous
        scTheme.layer.borderColor = UIColor.textFieldBorder.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func scThemeChange(_ sender: Any) {
        if delegate != nil {
            self.delegate.switchTapped(sender)
        }
    }
    
}
