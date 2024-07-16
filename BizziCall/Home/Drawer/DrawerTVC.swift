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
    
    let halfSizeTransitioningDelegate = HalfSizeTransitioningDelegate()
    private var sideMenuViewController: DrawerTVC!
    private var isSideMenuOpen = false
    private var isDarkModeEnabled: Bool = false
    
    let menuItems = ["Status", "Contacts", "History", "Change Number", "Theme"]
    let menuItemsImages = ["status","contacts", "history", "changeNumber","theme"]// Example items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        setupTableView()
        checkDarKMode()
        isSideMenuOpen = true
//        isDarkModeEnabled =  UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
    }
    
//    override func viewWillAppear(_ animated: Bool) {
////        isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkMode")
//        checkDarKMode()
//    }
    func checkDarKMode() {
        if traitCollection.userInterfaceStyle == .dark {
            print("Dark mode is enabled")
            isDarkModeEnabled = true
        } else {
            print("Light mode is enabled")
            isDarkModeEnabled = false
        }
    }
    
    
    func setupGesture() {
        let removeAccountGesture = UITapGestureRecognizer(target: self, action: #selector(removeAccountTapped))
        vwRemoveAccount?.addGestureRecognizer(removeAccountGesture)
        vwRemoveAccount?.isUserInteractionEnabled = true
    }
    
    func setupTableView() {
        self.tableView.register(UINib(nibName: "MenuItemCell", bundle: nil), forCellReuseIdentifier: "MenuItemCell")
        self.tableView.register(UINib(nibName: "ChangeThemeCell", bundle: nil), forCellReuseIdentifier: "ChangeThemeCell")
    }
    
    @objc func removeAccountTapped() {
        presentHalfScreenViewController()
    }
    
    func presentHalfScreenViewController() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let removeAccountVC = storyboard.instantiateViewController(withIdentifier: "RemoveAccountVC") as?  RemoveAccountVC{
            
            removeAccountVC.modalPresentationStyle = .custom
            removeAccountVC.transitioningDelegate = halfSizeTransitioningDelegate
            present(removeAccountVC, animated: true, completion: nil)
            
        }
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
            print("theme clicked")
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
        
        UserDefaults.standard.set(isDarkModeEnabled, forKey: "isDarkMode")
        if let window = UIApplication.shared.windows.first {
            window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        }
    }
    
    @IBAction func btnMenuTapped(_ sender: Any) {
        toggleSideMenu()
    }
    
    private func toggleSideMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            if self.isSideMenuOpen {
                // Hide side menu
                self.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width * 0, height: self.view.frame.height)
            } else {
                // Show side menu
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0, height: self.view.frame.height)
            }
        }) { _ in
            
            self.isSideMenuOpen.toggle()
        }
    }

}

extension DrawerTVC: swithcControlDelegate {
    func switchTapped(_ sender: Any) {
        changeTheme()
        self.tableView.reloadData()
        toggleSideMenu()
    }
}

extension DrawerTVC {
    
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
            cell.scTheme.onTintColor = .switchTint
            
            //            cell.scTheme.tintColor = isDarkModeEnabled ? .gradientEnd : .appBasic
            cell.scTheme.thumbTintColor = .switchThumb // isDarkModeEnabled ? .appBasic : .gradientStart
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
    
}
