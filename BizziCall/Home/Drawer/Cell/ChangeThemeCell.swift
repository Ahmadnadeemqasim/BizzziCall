//
//  ChangeThemeCell.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 6/9/24.
//

import UIKit

class ChangeThemeCell: UITableViewCell {
    @IBOutlet weak var lblMenuItem: UILabel!
    @IBOutlet weak var imgMenuItem: UIImageView!
    @IBOutlet weak var lblTheme: UILabel!
    @IBOutlet weak var scTheme: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func scThemeChange(_ sender: Any) {
        
    }
    
}
