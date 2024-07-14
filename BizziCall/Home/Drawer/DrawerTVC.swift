//
//  DrawerTVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/29/24.
//

import UIKit
import QuartzCore

class DrawerTVC: UITableViewController {
    
    @IBOutlet weak var vwRemoveAccount: UIView!
 
    private var isDarkModeEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isDarkModeEnabled")
        }
    }

    
    let menuItems = ["Status", "Contacts", "History", "Change Number", "Theme"]
    let menuItemsImages = ["status","contacts", "history", "changeNumber","theme"]// Example items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupTableView()
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
    
    
    func setupGesture() {
        let removeAccountGesture = UITapGestureRecognizer(target: self, action: #selector(removeAccountTapped))
        vwRemoveAccount?.addGestureRecognizer(removeAccountGesture)
        vwRemoveAccount?.isUserInteractionEnabled = true
    }
    
    
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "MenuItemCell")
        self.tableView.register(UINib(nibName: "LogoutCell", bundle: nil), forCellReuseIdentifier: "LogoutCell")
        self.tableView.register(UINib(nibName: "ChangeThemeCell", bundle: nil), forCellReuseIdentifier: "ChangeThemeCell")
    }
    
    @objc func removeAccountTapped() {
        presentHalfScreenViewController()
    }
    
    let halfSizeTransitioningDelegate = HalfSizeTransitioningDelegate()
    
    func presentHalfScreenViewController() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let removeAccountVC = storyboard.instantiateViewController(withIdentifier: "RemoveAccountVC") as?  RemoveAccountVC{
            
            removeAccountVC.modalPresentationStyle = .custom
            removeAccountVC.transitioningDelegate = halfSizeTransitioningDelegate
            present(removeAccountVC, animated: true, completion: nil)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeThemeCell", for: indexPath) as! ChangeThemeCell
            cell.lblMenuItem?.text = menuItems[indexPath.row]
            cell.imgMenuItem?.image = UIImage(named:menuItemsImages[indexPath.row])
            cell.lblTheme.text = isDarkModeEnabled ?  "Dark" : "Light"
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
            cell.lblMenuItem?.text = menuItems[indexPath.row]
            cell.imgMenuItem?.image = UIImage(named:menuItemsImages[indexPath.row])
            
            cell.selectionStyle = .none
            return cell
        }
    }
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateToViewController(at: indexPath.row)
    }
    
    private func navigateToViewController(at index: Int) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        var viewController: UIViewController?
        
        
        switch menuItems[index] {
        case "Status":
            viewController = storyboard.instantiateViewController(withIdentifier: "StatusVC")
        case "Contacts":
            viewController = storyboard.instantiateViewController(withIdentifier: "ContactsVC")
        case "History":
            viewController = storyboard.instantiateViewController(withIdentifier: "HistoryVC")
        case "Change Number":
            viewController = storyboard.instantiateViewController(withIdentifier: "ChangeNumberVC")
        case "Social Notifications":
            viewController = storyboard.instantiateViewController(withIdentifier: "NotificationVC")
        case "Theme":
            viewController = navigationController?.viewControllers[1]
            changeTheme()
        default:
            break
        }
        
        
        
        if let viewController = viewController {
            navigationController?.popToRootViewController(animated: false)
//            navigationController?.popViewController(animated: false)
            let transition = CATransition()
            transition.duration = 0.4 // Duration of the transition
            transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
            transition.type = .fade
            transition.subtype = .none
            
            view.window?.layer.add(transition, forKey: kCATransition)
            
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        }
        
        // Dismiss the side menu after selection
        if let parentVC = parent as? StatusVC  {
            parentVC.dismissSideMenu(sideMenu: self)
        }
    }
    func changeTheme() {
        isDarkModeEnabled.toggle()
        
        if isDarkModeEnabled {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        
        if let window = UIApplication.shared.windows.first {
            window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        }
    }
}

extension DrawerTVC: swithcControlDelegate {
    func switchTapped(_ sender: Any) {
        changeTheme()
        self.tableView.reloadData()
    }
}
