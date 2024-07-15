//
//  CustomSettingsVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/28/24.
//

import UIKit

class CustomSettingsVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var txtViewCustomeMessage: UITextView!
    @IBOutlet weak var txtFieldStatus: UITextField!
    @IBOutlet weak var txtFieldToHour: UITextField!
    @IBOutlet weak var txtFieldToMinutes: UITextField!
    @IBOutlet weak var txtFieldFromHour: UITextField!
    @IBOutlet weak var txtFieldFromMinutes: UITextField!
    @IBOutlet weak var sgbarToTime: UISegmentedControl!
    @IBOutlet weak var sgbarFromTime: UISegmentedControl!
    @IBOutlet weak var btnDone: UIButton!
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Write custom status...."
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtViewCustomeMessage.delegate = self
        populateFromSectionWithCurrentTime()
        setupTextField()
        // Do any additional setup after loading the view.
        
        customizeSegmentedControl(segmentedControl: sgbarToTime)
        customizeSegmentedControl(segmentedControl: sgbarFromTime)
        
        // Add placeholder label to text view
        txtViewCustomeMessage.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: txtViewCustomeMessage.font?.pointSize ?? 14 / 2)
        placeholderLabel.isHidden = !txtViewCustomeMessage.text.isEmpty
        
        updateStatusText()
        
        txtFieldToHour.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtFieldToMinutes.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtFieldStatus.isEnabled = false
        txtFieldStatus.isUserInteractionEnabled = false
        
        // Add target actions for editingDidEnd to validate the inputs
        txtFieldToHour.delegate = self
        txtFieldToMinutes.delegate = self
        txtFieldToHour.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        txtFieldToMinutes.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)

    }
    
  
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
        updateStatusText()
    }
    
    func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !txtViewCustomeMessage.text.isEmpty
    }
    
    func updateStatusText() {
        let message = txtViewCustomeMessage.text ?? ""
        let toHour = Int(txtFieldToHour.text ?? "0") ?? 0
        let toMinute = Int(txtFieldToMinutes.text ?? "0") ?? 0
        let toIsPM = sgbarToTime.selectedSegmentIndex == 1
        
        let toTimeString = String(format: "%02d:%02d %@", toHour, toMinute, toIsPM ? "PM" : "AM")
        
        if message.isEmpty {
            txtFieldStatus.text = "Available at \("2:00 PM")"
        } else {
            txtFieldStatus.text = "\(message) and available at \(toTimeString)"
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateStatusText()
    }
    

//    @IBAction func toSegmentControlTapped(_ sender: UISegmentedControl){
//        switch sender.selectedSegmentIndex {
//        case 0:
//            updateStatusText()
//        case 1:
//            updateStatusText()
//        default:
//            break
//        }
//
//    }
    
    @IBAction func toSegmentControlTapped(_ sender: UISegmentedControl) {
        updateStatusText()
    }
    
    @IBAction func fromSegmentControlTapped(_ sender: UISegmentedControl) {
        updateStatusText()
    }

    
    @IBAction func btnDoneTapped(_ sender: UIButton){
        
        if checkValidation() {
            handleNavigation()
        }
    }
    
    func handleNavigation() {
        let message = txtViewCustomeMessage.text
        let fromHour = Int(txtFieldFromHour.text ?? "0") ?? 0
        let fromMinute = Int(txtFieldFromMinutes.text ?? "0") ?? 0
        let fromIsPM = sgbarFromTime.selectedSegmentIndex == 1
        
        let toHour = Int(txtFieldToHour.text ?? "0") ?? 0
        let toMinute = Int(txtFieldToMinutes.text ?? "0") ?? 0
        let toIsPM = sgbarToTime.selectedSegmentIndex == 1
        
        let fromTimeString = String(format: "%02d:%02d %@", fromHour, fromMinute, fromIsPM ? "PM" : "AM")
        let toTimeString = String(format: "%02d:%02d %@", toHour, toMinute, toIsPM ? "PM" : "AM")
        
        let duration = "\(fromTimeString) - \(toTimeString)"
        
        if let statusVC = self.navigationController?.viewControllers.first(where: { $0 is StatusVC }) as? StatusVC {
            statusVC.selectedMessage = message
            statusVC.selectedDuration = duration
            statusVC.selectedMessageButton  = nil
            statusVC.selectedDurationButton =  nil
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkValidation() -> Bool {
        if txtViewCustomeMessage.text.isEmpty {
            showAlert(message: "Please enter custom message")
            return false
        }
        if (txtFieldToHour.text == "") {
            showAlert(message: "Please enter custom time")
            return false
        }
        
        return true
    }

    @IBAction func btnBackTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMenuTapped(_ sender: UIButton){
        print("---------Menu Button Tapped-------------")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        if let drawerVC = storyboard.instantiateViewController(withIdentifier: "DrawerTVC") as? DrawerTVC {
            drawerVC.modalTransitionStyle = .partialCurl
            //                        self.show(drawerVC, sender: self)
            
            self.navigationController?.pushViewController(drawerVC, animated: true)
        }
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension CustomSettingsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only numeric input
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFieldToHour {
            validateHourTextField()
        } else if textField == txtFieldToMinutes {
            validateMinuteTextField()
        }
    }
    
    func validateHourTextField() {
        guard let text = txtFieldToHour.text, let hour = Int(text), hour >= 1, hour <= 12 else {
            txtFieldToHour.text = ""
            return
        }
    }
    
    func validateMinuteTextField() {
        guard let text = txtFieldToMinutes.text, let minute = Int(text), minute >= 0, minute <= 59 else {
            txtFieldToMinutes.text = ""
            return
        }
    }
}
