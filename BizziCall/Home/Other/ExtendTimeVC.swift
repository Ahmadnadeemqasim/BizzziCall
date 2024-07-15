//
//  ExtendTimeVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/29/24.
//

import UIKit

class ExtendTimeVC: UIViewController {

    @IBOutlet weak var btn15Minutes: UIButton!
    @IBOutlet weak var btn45Minutes: UIButton!
    @IBOutlet weak var btn1Hour: UIButton!
    @IBOutlet weak var btn2Hour: UIButton!
    @IBOutlet weak var btn3Hour: UIButton!
    @IBOutlet weak var btn4Hour: UIButton!
    @IBOutlet weak var btnAvailabe: UIButton!
    @IBOutlet weak var btnExtendTime: UIButton!
    @IBOutlet weak var lblStatusEndTime: UILabel!
    @IBOutlet weak var txtStatusMessage: UITextField!
    @IBOutlet weak var extendTimeView: UIView!
    @IBOutlet weak var extTimeHeightConstraint: NSLayoutConstraint!
    
    var message: String = ""
    var availableTime: String = ""
    
    private var selectedDurationButton: UIButton?
    
    var selectedDuration: String?
    var selectedAvailabilty: TimeInterval = 0
    var statusString = ""
    
    private var sideMenuViewController: DrawerTVC!
    private var isSideMenuOpen = false
    var userStatus = StatusModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        extendTimeView.isHidden = true
        extTimeHeightConstraint.constant = 0.0
        lblStatusEndTime.text = availableTime
        txtStatusMessage.text = "\(message) \(availableTime)"
        // Do any additional setup after loading the view.
    }
    
    private func setupButtons() {
        let buttons: [UIButton] = [btn15Minutes, btn45Minutes, btn1Hour, btn2Hour, btn3Hour, btn4Hour]
        
        for button in buttons {
            button.layer.cornerRadius = 7.0
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        }
        btnAvailabe.layer.cornerRadius = 7.0
        btnExtendTime.layer.cornerRadius = 7.0
        
    }
    
    @objc private func handleButtonTap(_ sender: UIButton) {

        if [btn15Minutes, btn45Minutes, btn1Hour, btn2Hour, btn3Hour, btn4Hour].contains(sender) {
            handleDurationButton(sender)
        }
    }
    
    private func handleDurationButton(_ sender: UIButton) {
        // Deselect the previous duration button
        if let previousButton = selectedDurationButton {
            previousButton.layer.borderWidth = 1.0
            previousButton.layer.borderColor = UIColor.clear.cgColor
        }
        
//        if selectedDurationButton != sender {
//            selectedAvailabilty = 0
//        }
        
        // Select the new duration button
        sender.layer.borderWidth = 1.0
        sender.layer.borderColor = UIColor.btnBorder.cgColor
        selectedDurationButton = sender
        
        // Save the selected duration
        switch sender {
        case btn15Minutes:
            selectedDuration = "15 Minutes"
        case btn45Minutes:
            selectedDuration = "45 Minutes"
        case btn1Hour:
            selectedDuration = "1 Hour"
        case btn2Hour:
            selectedDuration = "2 Hours"
        case btn3Hour:
            selectedDuration = "3 Hours"
        case btn4Hour:
            selectedDuration = "4 Hours"
        default:
            selectedDuration = "0"
        }
        
        if let duration = selectedDuration {
            let availabilityTime = calculateAvailabilityTime(duration: duration)
            statusString = "\(message) \(availabilityTime)"
            txtStatusMessage.text = statusString
            lblStatusEndTime.text = availabilityTime
        }
    }
    
    private func calculateAvailabilityTime(duration: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        // Get the current time
        let currentTime = Date()
        
        // Determine the time interval based on the selected duration
        var timeInterval: TimeInterval = 0
        switch duration {
        case "15 Minutes":
            timeInterval = 15 * 60
        case "45 Minutes":
            timeInterval = 45 * 60
        case "1 Hour":
            timeInterval = 60 * 60
        case "2 Hours":
            timeInterval = 2 * 60 * 60
        case "3 Hours":
            timeInterval = 3 * 60 * 60
        case "4 Hours":
            timeInterval = 4 * 60 * 60
        default:
            break
        }
        
        // Calculate the new availability time
        selectedAvailabilty += timeInterval
        let availability = currentTime.addingTimeInterval(selectedAvailabilty)
        
        // Format the availability time
        return dateFormatter.string(from: availability)
    }
    
    
    @IBAction func btn15MinutesTapped(_ sender: UIButton) {  }
    
    @IBAction func btn45MinutesTapped(_ sender: UIButton) {  }
    
    @IBAction func btn1HourTapped(_ sender: UIButton) { }
    
    @IBAction func btn2HourTapped(_ sender: UIButton) {    }
    
    
    @IBAction func btn3HourTapped(_ sender: UIButton) {    }
    
    @IBAction func btn4HourTapped(_ sender: UIButton) {    }
    
    @IBAction func btnAvailableTapped(_ sender: UIButton) { 
        FirebaseDatabaseManager.shared.updateStatus(status: "")
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let customSettingsVC = storyboard.instantiateViewController(withIdentifier: "HistoryVC") as? HistoryVC {
            customSettingsVC.modalTransitionStyle = .coverVertical
            customSettingsVC.modalPresentationStyle = .overCurrentContext
//            self.navigationController?.pushViewController(customSettingsVC, animated: true)
            
            present(customSettingsVC, animated: true)
        }
    }
    
    @IBAction func btnExtendTimeTapped(_ sender: UIButton){
        extendTimeView.isHidden = false
        extTimeHeightConstraint.constant = 165.0
    }
    
    @IBAction func btnMenuTapped(_ sender: UIButton) {
        toggleSideMenu()
    }
    
    private func toggleSideMenu() {
        UIView.animate(withDuration: 0.3, animations: {
            if self.isSideMenuOpen {
                // Hide side menu
                self.sideMenuViewController.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height)
            } else {
                // Show side menu
                self.sideMenuViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8, height: self.view.frame.height)
            }
        }) { _ in
            self.isSideMenuOpen.toggle()
        }
    }
    
    private func setupSideMenu() {
        // Instantiate SideMenuViewController from storyboard
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "DrawerTVC") as? DrawerTVC
        
        // Add SideMenuViewController as child
        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
        
        // Set initial frame (off-screen)
        sideMenuViewController.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width * 0.65, height: view.frame.height)
    }
}
