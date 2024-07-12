//
//  VerifyOTPVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/27/24.
//
//

import UIKit
import Firebase
import FirebaseAuth

class VerifyOTPVC: UIViewController {
    
    var ref: DatabaseReference!
    @IBOutlet weak var verifyOTPButton: UIButton!
    @IBOutlet weak var txtOTP1: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP4: UITextField!
    @IBOutlet weak var txtOTP5: UITextField!
    @IBOutlet weak var txtOTP6: UITextField!
    
    @IBOutlet weak var lblTimer: UILabel!
//    @IBOutlet weak var lblResend: UILabel!
    
    let otp: String = "123456"
    var timer: Timer?
    var remainingTime: Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        startTimer()
    }
    
    func setupTextFields() {
        let textFields: [UITextField] = [txtOTP1, txtOTP2, txtOTP3, txtOTP4, txtOTP5, txtOTP6]
        for (index, textField) in textFields.enumerated() {
            textField.delegate = self
            textField.layer.cornerRadius = 4.0
            textField.layer.masksToBounds = true
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            textField.tag = index
        }
    }
    
    func startTimer() {
        lblTimer.isEnabled = false
//        lblTimer.isHidden = false
        remainingTime = 60
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if remainingTime > 0 {
            lblTimer.isEnabled = false
            remainingTime -= 1
            lblTimer.text = "Resend in 00: \(remainingTime)"
        } else {
            lblTimer.isEnabled = true
            let resendTap = UITapGestureRecognizer(target: self, action: #selector(resendOTP))
            lblTimer.text = "Resend Now"
            lblTimer.isUserInteractionEnabled = true
            lblTimer.addGestureRecognizer(resendTap)
            timer?.invalidate()
//            lblTimer.isHidden = false
        }
    }
    
    @objc func resendOTP() {
        // Regenerate OTP logic here if needed
        resetFields()
        startTimer()
    }
    
    func resetFields() {
        let textFields: [UITextField] = [txtOTP1, txtOTP2, txtOTP3, txtOTP4, txtOTP5, txtOTP6]
        for textField in textFields {
            textField.text = ""
            textField.layer.cornerRadius = 4.0
            textField.layer.masksToBounds = true
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.layer.borderWidth = 1.0
        }
        txtOTP1.becomeFirstResponder()
    }
    
    @IBAction func btnVerifyOTPTapped(sender: UIButton) {
        let enteredOTP = "\(txtOTP1.text ?? "")\(txtOTP2.text ?? "")\(txtOTP3.text ?? "")\(txtOTP4.text ?? "")\(txtOTP5.text ?? "")\(txtOTP6.text ?? "")"
        
        if enteredOTP.isEmpty {
            showAlert(message: "Please enter the OTP.")
            return
        }
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            showAlert(message: "Verification ID not found.")
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: enteredOTP)
        
        // Sign in with the credential
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(message: error.localizedDescription)
                
                return
            }
            
            // OTP verification successful, navigate to the next screen
            self!.navigateToNextVC()
        }
    }
    
    func navigateToNextVC(){
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = sceneDelegate.getInitialViewController()
        }
        
    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in 
            UserDefaults.standard.removeObject(forKey: "currentUserNumber")
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textField.layer.borderColor = UIColor.textFieldBorder.cgColor // UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
        textField.backgroundColor = UIColor.appBasic
        
        if text.count > 1 {
            textField.text = String(text.prefix(1))
        }
        
        let nextTag = textField.tag + 1
        if nextTag < 6, text.count == 1 {
            let nextResponder = textField.superview?.viewWithTag(nextTag) as? UITextField
            nextResponder?.becomeFirstResponder()
            nextResponder?.backgroundColor = UIColor.textViewBackground
            nextResponder?.layer.borderColor = UIColor.gradientStart.cgColor
        }
        
        if text.count == 0, textField.tag >= 0 {
            let previousTag = textField.tag - 1
            let previousResponder = textField.superview?.viewWithTag(previousTag) as? UITextField
            previousResponder?.becomeFirstResponder()
        }
    }
}

extension VerifyOTPVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length
        return newLength <= 1
    }
}
