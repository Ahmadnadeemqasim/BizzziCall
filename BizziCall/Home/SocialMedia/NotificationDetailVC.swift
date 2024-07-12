//
//  NotificationDetailVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/29/24.
//

import UIKit

class AppNotificationListCell: UITableViewCell {
    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var lblNotificationDetail: UILabel!
}

class NotificationDetailVC: UIViewController {

    @IBOutlet weak var tblNotificationList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

}
