//
//  StatusVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/28/24.
//

import UIKit

struct StatusModel: Codable {
    var message: String?
    var duration: String?
}

class StatusVC: UIViewController {
    
    private var sideMenuViewController: DrawerTVC!
    private var isSideMenuOpen = false
    var userStatus = StatusModel()
    
    var selectedMessageButton: UIButton?
    var selectedDurationButton: UIButton?
    
    var selectedMessage: String?
    var selectedDuration: String?
    var selectedAvailabilty: TimeInterval = 0
    var statusString = ""
    
    @IBOutlet weak var btnRealBusy: UIButton!
    @IBOutlet weak var btnDriving: UIButton!
    @IBOutlet weak var btnWithFamily: UIButton!
    @IBOutlet weak var btnATWork: UIButton!
    @IBOutlet weak var btnAtParty: UIButton!
    @IBOutlet weak var btnSleeping: UIButton!
    @IBOutlet weak var btn15Minutes: UIButton!
    @IBOutlet weak var btn45Minutes: UIButton!
    @IBOutlet weak var btn1Hour: UIButton!
    @IBOutlet weak var btn2Hour: UIButton!
    @IBOutlet weak var btn3Hour: UIButton!
    @IBOutlet weak var btn4Hour: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCustomSetting: UIButton!
    @IBOutlet weak var txtStatusMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupSideMenu()
//        selectedMessageButton = btnRealBusy
//        selectedDurationButton = btn15Minutes
        FirebaseDatabaseManager.shared.fetchDataFromFirebase { data in
            if let data = data {
                CoreDataManager.shared.saveDataToCoreData(data: data)
            }
        }
//        screenLoadStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSideMenu()
        if let message = selectedMessage {
            let availabilityTime = calculateAvailabilityTime(duration: selectedDuration ?? "0")
            txtStatusMessage.text = "\(message) and available at \(availabilityTime)"
            statusString = "\(message) and available at \(availabilityTime)"
        }
    }
    
    func screenLoadStatus() {
        selectedMessage = "Real Busy"
        selectedDuration = "15 Minutes"
        
        if let message = selectedMessage, let duration = selectedDuration {
            let availabilityTime = calculateAvailabilityTime(duration: duration)
            txtStatusMessage.text = "\(message) and available at \(availabilityTime)"
        }
    }
    
    
    private func setupButtons() {
        let buttons: [UIButton] = [btnRealBusy, btnDriving, btnWithFamily, btnATWork, btnAtParty, btnSleeping, btn15Minutes, btn45Minutes, btn1Hour, btn2Hour, btn3Hour, btn4Hour, btnDone, btnCustomSetting]
        for button in buttons {
            button.layer.cornerRadius = 7.0
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        }
        
//        btnRealBusy.layer.borderWidth = 1.0
//        btn15Minutes.layer.borderWidth = 1.0
        btnCustomSetting.layer.borderWidth = 1.0
//        btnRealBusy.layer.borderColor = UIColor.btnBorder.cgColor
//        btn15Minutes.layer.borderColor = UIColor.btnBorder.cgColor
        btnCustomSetting.layer.borderColor = UIColor.buttonText.cgColor
    }
    
    @objc private func handleButtonTap(_ sender: UIButton) {
        if [btnRealBusy, btnDriving, btnWithFamily, btnATWork, btnAtParty, btnSleeping].contains(sender) {
            handleStatusMessageButton(sender)
        } else if [btn15Minutes, btn45Minutes, btn1Hour, btn2Hour, btn3Hour, btn4Hour].contains(sender) {
            handleDurationButton(sender)
        }
    }
    
    private func handleStatusMessageButton(_ sender: UIButton) {
        // Deselect the previous message button
        if let previousButton = selectedMessageButton {
            previousButton.layer.borderWidth = 1.0
            previousButton.layer.borderColor = UIColor.clear.cgColor
            
//            previousButton.setTitleColor(.black, for: .normal)
        }
        
        // Select the new message button
        sender.layer.borderWidth = 1.0
        sender.layer.borderColor = UIColor.btnBorder.cgColor
        selectedMessageButton = sender
        
        // Save the selected message
        switch sender {
        case btnRealBusy:
            selectedMessage = "Real Busy"
        case btnDriving:
            selectedMessage = "Driving"
        case btnWithFamily:
            selectedMessage = "With Family"
        case btnATWork:
            selectedMessage = "At Work"
        case btnAtParty:
            selectedMessage = "At Party"
        case btnSleeping:
            selectedMessage = "Sleeping"
        default:
            selectedMessage = nil
        }
        
        if let message = selectedMessage {
            let availabilityTime = calculateAvailabilityTime(duration: "0")
            txtStatusMessage.text = "\(message) and available at \(availabilityTime)"
            statusString = "\(message) and available at \(availabilityTime)"
        }
    }
    
    private func handleDurationButton(_ sender: UIButton) {
        // Deselect the previous duration button
        if let previousButton = selectedDurationButton {
            previousButton.layer.borderWidth = 1.0
            previousButton.layer.borderColor = UIColor.clear.cgColor
        }
        
        if selectedDurationButton != sender {
            selectedAvailabilty = 0
        }
        
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
            selectedDuration = nil
        }
        
        if let message = selectedMessage, let duration = selectedDuration {
            let availabilityTime = calculateAvailabilityTime(duration: duration)
            txtStatusMessage.text = "\(message) and available at \(availabilityTime)"
            statusString = "\(message) and available at \(availabilityTime)"
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
//        selectedAvailabilty += timeInterval
        let availability = currentTime.addingTimeInterval(timeInterval)
        
        // Format the availability time
        return dateFormatter.string(from: availability)
    }
    
    @IBAction func btnRealBusyTapped(_ sender: UIButton) { }
    @IBAction func btnDrivingTapped(_ sender: UIButton) { }
    @IBAction func btnWithFamilyTapped(_ sender: UIButton) { }
    @IBAction func btnAtWorkTapped(_ sender: UIButton) { }
    @IBAction func btnAtPartyTapped(_ sender: UIButton) { }
    @IBAction func btnSleepingTapped(_ sender: UIButton) { }
    @IBAction func btn15MinutesTapped(_ sender: UIButton) { }
    @IBAction func btn45MinutesTapped(_ sender: UIButton) { }
    @IBAction func btn1HourTapped(_ sender: UIButton) { }
    @IBAction func btn2HourTapped(_ sender: UIButton) { }
    @IBAction func btn3HourTapped(_ sender: UIButton) { }
    @IBAction func btn4HourTapped(_ sender: UIButton) { }
    
    @IBAction func btnCustomTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let customSettingsVC = storyboard.instantiateViewController(withIdentifier: "CustomSettingsVC") as? CustomSettingsVC {
            customSettingsVC.modalTransitionStyle = .flipHorizontal
            navigationController?.pushViewController(customSettingsVC, animated: true)
        }
    }
    
    @IBAction func btnDoneTapped(_ sender: UIButton) {
        // Example: Save the selected message and duration to userStatus
        userStatus.message = selectedMessage
        userStatus.duration = selectedDuration
        
        // Optionally, you can print or handle the userStatus here
        print("Selected message: \(userStatus.message ?? "None")")
        print("Selected duration: \(userStatus.duration ?? "None")")
        
        
        FirebaseDatabaseManager.shared.updateStatus(status: statusString)
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let extendVC = storyboard.instantiateViewController(withIdentifier: "ExtendTimeVC") as? ExtendTimeVC
        
        if let viewController = extendVC {
            navigationController?.popToRootViewController(animated: false)
            //            navigationController?.popViewController(animated: false)
            let transition = CATransition()
            transition.duration = 0.4 // Duration of the transition
            transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
            transition.type = .fade
            transition.subtype = .none
            viewController.message = selectedMessage ?? ""
            let availabilityTime = calculateAvailabilityTime(duration: selectedDuration ?? "0")
            viewController.availableTime = availabilityTime
            view.window?.layer.add(transition, forKey: kCATransition)
            
            //            viewController.modalTransitionStyle = .
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: false, completion: nil)
        }
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
