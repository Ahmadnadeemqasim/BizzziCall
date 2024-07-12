//
//  PermissionVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/28/24.
//
//

import UIKit
import WebKit

class PermissionVC: UIViewController {
    
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var lblAllow: UILabel!
    @IBOutlet weak var lblDeny: UILabel!
    @IBOutlet weak var lblPRivacyPolicy: UIView!
    @IBOutlet weak var lbWebLLink: UIView!
    @IBOutlet weak var vwPRivacyPolicy: UIView!
    @IBOutlet weak var vwWebLLink: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScreenView()
        setupGestures()
        setupLabelTap()
        setupDenyLabel()
    }
    
    
    func setupLabelTap() {
        let text = "When you click Allow your away message will appear on your contact list"
        let allowRange = (text as NSString).range(of: "Allow")
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.allowLink, range: allowRange)
        
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: allowRange)
        
        lblAllow.attributedText = attributedString
        lblAllow.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
        lblAllow.addGestureRecognizer(tapGesture)
        
    }
    
    func setupDenyLabel() {
        let text = "Click Deny to close the app"
        let denyRange = (text as NSString).range(of: "Deny")
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.allowLink, range: denyRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: denyRange)
        
        lblDeny.attributedText = attributedString
        lblDeny.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDenyLabelTap(_:)))
        lblDeny.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleLabelTap(_ gesture: UITapGestureRecognizer) {
        guard let text = lblAllow.attributedText?.string else { return }
        let allowRange = (text as NSString).range(of: "Allow")
        
        if gesture.didTapAttributedTextInLabel(label: lblAllow, inRange: allowRange) {
            // Navigate to the next view controller
            if let nextVC = storyboard?.instantiateViewController(withIdentifier: "AgreementVC") as? AgreementVC {
                nextVC.modalPresentationStyle = .fullScreen
                present(nextVC, animated: true)
            }
        }
    }
    
    @objc func handleDenyLabelTap(_ gesture: UITapGestureRecognizer) {
        guard let text = lblDeny.attributedText?.string else { return }
        let denyRange = (text as NSString).range(of: "Deny")
        if gesture.didTapAttributedTextInLabel(label: lblDeny, inRange: denyRange) {
            exit(0)
        }
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
}

class WebViewController: UIViewController {
    
    var url: URL?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView(frame: self.view.frame)
        self.view.addSubview(webView)
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        // Add a close button
        let closeButton = UIButton(frame: CGRect(x: 20, y: 40, width: 50, height: 30))
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.blue, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}



// Extension to detect if tap is within the specified range of the attributed string
extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        guard let attributedText = label.attributedText else { return false }
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
        mutableAttributedString.addAttributes([.font: label.font!], range: NSRange(location: 0, length: attributedText.length))
        
        let textStorage = NSTextStorage(attributedString: mutableAttributedString)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (label.bounds.size.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (label.bounds.size.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        let indexOfCharacter = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
