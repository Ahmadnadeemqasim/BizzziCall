//
//  ChangeNumberVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/29/24.
//

import UIKit
import FirebaseAuth
import NKVPhonePicker

class ChangeNumberVC: UIViewController {
    
    private var sideMenuViewController: DrawerTVC!
    private var isSideMenuOpen = false

    
    @IBOutlet weak var btnChangeNumber: UIButton!
    @IBOutlet weak var txtFieldChangeNumber: NKVPhonePickerTextField!
    var bottomTextField: NKVPhonePickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSideMenu()
        setupCountryPicker()
        // Do any additional setup after loading the view.
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
        
        btnChangeNumber.layer.cornerRadius = 7.0
    }
    
    func setupCountryPicker() {
        txtFieldChangeNumber.phonePickerDelegate = self
        txtFieldChangeNumber.countryPickerDelegate = self
        txtFieldChangeNumber.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
        let country = Country.country(for: NKVSource(countryCode: "PK"))
        txtFieldChangeNumber.country = country
        
        txtFieldChangeNumber.customPhoneFormats = ["RU" : "# ### ### ## ##",
                                             "IN": "## #### #########",
                                             "PK": "## ### #######"]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func changeNumberTapped(_ sender: UIButton){
        
        guard let phoneNumber = txtFieldChangeNumber.phoneNumber, isValidPhoneNumber(phoneNumber) else {
            showAlert(message: "Please enter a valid phone number.")
            return
        }
        
        // Verify phone number with Firebase
        PhoneAuthProvider.provider().verifyPhoneNumber("+" + phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription)
                return
            }
            
            // Save the verificationID for later use
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            UserDefaults.standard.set(phoneNumber, forKey: "currentUserNumber")
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                
                sceneDelegate.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
            }
        }
        
    }
    
    @IBAction func btnMenuTapped(_ sender: UIButton){
        print("---------Menu Button Tapped-------------")
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
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberRegex = "^[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    // MARK: - Keyboard handling
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
    }
    
}

extension ChangeNumberVC: CountriesViewControllerDelegate {
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        print("✳️ Did select country: \(country)")
    }
    
    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        print("😕")
    }
}
