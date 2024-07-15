//
//  AgreementVC.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 11/07/2024.
//

import UIKit
import WebKit
import Contacts

class AgreementVC: UIViewController {

    
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var vwAgreementCard: UIView!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    var isChecked: Bool = false
    
    @IBOutlet weak var agreementLabel: UILabel!
    @IBOutlet weak var lblPRivacyPolicy: UIView!
    @IBOutlet weak var lbWebLLink: UIView!
    @IBOutlet weak var vwPRivacyPolicy: UIView!
    @IBOutlet weak var vwWebLLink: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setScreenView()
        setupGestures()
        setupAgreementText()
//        btnContinue.isEnabled = isChecked
    }
    
    @IBAction func btnCheckBox(_ sennder: UIButton) {
        isChecked = !isChecked
        let imageString = isChecked ? "checkmark.square" : "square"
        let image = UIImage(systemName: imageString)
        btnCheckBox.setImage(image, for: .normal)
    }
    
    @IBAction func btnContinue(_ sennder: UIButton) {
        if !isChecked {
            showAlert(message: "You must have to agree with terms and condions to continue")
        } else {
            checkContactsPermission()
        }

    }
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
         
        }))
        present(alertController, animated: true, completion: nil)
    }

    func setupAgreementText() {
        let introText = """
        The mBizzi App requires permissions to post, read, and display Bizzi Messages, and to notify callers when you’re busy and when you’ll be available. It also stores your calls, texts, emails, and social media notifications for you to review later. See our privacy statement.
        
        """
        let agreementText = """
        1. Posting a Bizzi message adds a red dot next to contacts, showing you're unavailable.
        2. Important calls can still come through while your Bizzi message is active.
        3. Notifications from Facebook, Instagram, and other apps are saved for later viewing.
        4. Your Bizzi message is visible to everyone on your contact list.
        """
        
        let fullText = introText + agreementText
        let attributedString = NSMutableAttributedString(string: fullText)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = 2 // Adjust the line spacing as needed
        paragraphStyle.paragraphSpacing = 5 // Adjust the paragraph spacing as needed
        
        // Add attributes to the entire string
        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.buttonText,
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedString.length))
        
        // Optionally, style the numbers differently
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: UIColor.black
        ]
        
        // Apply the number attributes
        let numbers = ["1.", "2.", "3.", "4."]
        for number in numbers {
            if let range = fullText.range(of: number) {
                let nsRange = NSRange(range, in: fullText)
                attributedString.addAttributes(numberAttributes, range: nsRange)
            }
        }
        
        agreementLabel.attributedText = attributedString
        agreementLabel.numberOfLines = 0 // Ensure the label can display multiple lines
    }
    
    func setScreenView() {
        
        guard let vwCard = vwCard else {
            return
        }
        
        vwCard.translatesAutoresizingMaskIntoConstraints = false
        vwCard.layer.cornerRadius = 10 // Adjust this value as needed
        vwCard.layer.masksToBounds = false
        vwCard.layer.borderWidth = 0.5
        vwCard.backgroundColor = UIColor.appBasic
        vwCard.layer.borderColor =  UIColor.lightGray.cgColor
        
        // Set shadow
        vwCard.layer.shadowColor = UIColor.gradientEnd.cgColor
        vwCard.layer.shadowOpacity = 0.5 // Adjust this value as needed
        vwCard.layer.shadowOffset = CGSize(width: 0, height: 2) // Adjust this value as needed
        vwCard.layer.shadowRadius = 4 // Adjust this value as needed
        
        // Set shadow path to only cover the bottom side
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: vwCard.bounds.height))
        shadowPath.addLine(to: CGPoint(x: 0, y: vwCard.bounds.height + vwCard.layer.shadowRadius))
        shadowPath.addLine(to: CGPoint(x: vwCard.bounds.width, y: vwCard.bounds.height + vwCard.layer.shadowRadius))
        shadowPath.addLine(to: CGPoint(x: vwCard.bounds.width, y: vwCard.bounds.height))
        shadowPath.close()
        
        vwCard.layer.shadowPath = shadowPath.cgPath
    }

    func setupGestures() {
        let privacyPolicyTapGesture = UITapGestureRecognizer(target: self, action: #selector(privacyPolicyTapped))
        vwPRivacyPolicy?.addGestureRecognizer(privacyPolicyTapGesture)
        vwPRivacyPolicy?.isUserInteractionEnabled = true
        
        let webLinkTapGesture = UITapGestureRecognizer(target: self, action: #selector(webLinkTapped))
        vwWebLLink?.addGestureRecognizer(webLinkTapGesture)
        vwWebLLink?.isUserInteractionEnabled = true
    }

    @objc func privacyPolicyTapped() {
        openWebView(urlString: "https://www.google.com")
    }
    
    @objc func webLinkTapped() {
        openWebView(urlString: "https://www.google.com")
    }

    func openWebView(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let webViewVC = WebViewController()
        webViewVC.url = url
        present(webViewVC, animated: true, completion: nil)
    }
    
    func checkContactsPermission() {
        let store = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorizationStatus {
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        self.checkOtherPermissions()
                    } else {
                        self.showContactsPermissionAlert()
                    }
                }
            }
        case .authorized:
            checkOtherPermissions()
        case .denied, .restricted:
            showContactsPermissionAlert()
        @unknown default:
            fatalError("Unknown authorization status")
        }
    }
    
    func checkOtherPermissions() {
        // Assuming you have more permissions to check
        // Add more permission checks here if necessary
        if allPermissionsGranted() {
            navigateToSignUp()
        } else {
            showContactsPermissionAlert()
        }
    }
    
    func showContactsPermissionAlert() {
        let alert = UIAlertController(title: "Contacts Permission Required",
                                      message: "This app needs access to your contacts to function properly. Please grant access in Settings.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { _ in
                    // Optionally, handle completion if needed
                })
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            exit(0) // Close the app if permissions are not granted
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func allPermissionsGranted() -> Bool {
        // Check if all required permissions are granted
        // Add more checks for other permissions if needed
        let contactsGranted = CNContactStore.authorizationStatus(for: .contacts) == .authorized
        // Add more checks for other permissions here
        
        return contactsGranted
    }
    
    func navigateToSignUp() {
        UserDefaults.standard.set(true, forKey: "permissionsGranted")
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        signUpVC.modalTransitionStyle = .crossDissolve
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
}
