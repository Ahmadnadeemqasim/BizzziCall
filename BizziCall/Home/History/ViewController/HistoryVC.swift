//
//  HistoryVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/29/24.
//

import UIKit

enum HistoryTab {
    case History
    case Notifications
}

class HistoryVC: UIViewController {
    
    
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var cvNotification: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lblScreenTitle: UILabel!
    
    var sideMenuViewController: DrawerTVC!
    var isSideMenuOpen = false
    var installedApps = [SocialApp]()
    let appIcon = ["whatsapp","twitter","facebook","gmail","instagram","skype"]
    var filteredAppIcons = [String]()
    var historyTableViewController: HistoryVC!
    var notificationViewController: NotificationVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        setupTableView()
        loadHistory()
        filterInstalledApps()
    }
    
    func setupTableView() {
        
        lblScreenTitle.text = "Missed calls and Messages"
        tblHistory.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        cvNotification.register(UINib.init(nibName: "NotificationCell", bundle: nil), forCellWithReuseIdentifier: "NotificationCell")
        
        tblHistory.delegate = self
        tblHistory.dataSource = self
        cvNotification.delegate = self
        cvNotification.dataSource = self
        
        tblHistory.reloadData()
    }
    
    func loadHistory() {
        lblScreenTitle.text = "Missed calls and Messages"
        cvNotification.isHidden = true
        tblHistory.isHidden = false
        tblHistory.reloadData()
    }
    
    func loadNotifications() {
        lblScreenTitle.text = "Notifications"
        tblHistory.isHidden = true
        cvNotification.isHidden = false
        cvNotification.reloadData()
    }
    
    private func filterInstalledApps() {
        filteredAppIcons = appIcon.filter { icon in
            let appScheme: String?
            switch icon {
            case "whatsapp":
                appScheme = "whatsapp://"
            case "twitter":
                appScheme = "twitter://"
            case "facebook":
                appScheme = "fb://"
            case "gmail":
                appScheme = "googlegmail://"
            case "instagram":
                appScheme = "instagram://"
            case "skype":
                appScheme = "skype://"
            default:
                appScheme = nil
            }
            if let scheme = appScheme, let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                return true
            }
            return false
        }
    }
    
}

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblHistory.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        return cell
    }
    
}
