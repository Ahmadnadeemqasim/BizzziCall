//
//  SignupVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/27/24.
//

import UIKit
import FirebaseAuth
import NKVPhonePicker


class SignupVC: UIViewController {
   @IBOutlet weak var txtPhoneNumber: NKVPhonePickerTextField!
    var bottomTextField: NKVPhonePickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCountryPicker()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var signUpButton: UIButton!
    
    func setupCountryPicker() {
        txtPhoneNumber.phonePickerDelegate = self
        txtPhoneNumber.countryPickerDelegate = self
        txtPhoneNumber.favoriteCountriesLocaleIdentifiers = ["RU", "ER", "JM"]
        let country = Country.country(for: NKVSource(countryCode: "PK"))
        txtPhoneNumber.country = country
        
        txtPhoneNumber.customPhoneFormats = ["RU" : "# ### ### ## ##",
                                           "IN": "## #### #########",
                                             "PK": "## ### #######"]

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

    }
  
    @IBAction func btnSignUpTapped(sender: UIButton) {
        print("---------Button Tapped-------------")
        guard let phoneNumber = txtPhoneNumber.phoneNumber, isValidPhoneNumber(phoneNumber) else {
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
            
            // Move to the next screen for OTP entry
            self?.performSegue(withIdentifier: "SignUpSegue", sender: self)
        }
  
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
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

extension SignupVC: CountriesViewControllerDelegate {
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        print("✳️ Did select country: \(country)")
    }
    
    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        print("😕")
    }
}
