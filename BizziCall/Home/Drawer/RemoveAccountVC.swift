//
//  RemoveAccountVC.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 7/13/24.
//

import UIKit
import FirebaseAuth

class RemoveAccountVC: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var vwPin: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCancel.layer.cornerRadius = 10.0
        btnContinue.layer.cornerRadius = 10.0
        vwPin.layer.cornerRadius = 0.5
        vwBackground.layer.cornerRadius = 20.0
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton) {
        print("---------------continue tapped-----------------")
        logout()
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            // Successfully signed out
            // Redirect the user to the login screen or perform any other necessary actions
            redirectToLoginScreen()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            // Handle the error if needed
        }
    }
    
    func redirectToLoginScreen() {
        // Assuming you are using a navigation controller
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "currentUserNumber")
        UserDefaults.standard.removeObject(forKey: "authVerificationID")
        UserDefaults.standard.removeObject(forKey: "currentUserNumber")
        UserDefaults.standard.set(false, forKey: "permissionsGranted")
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let removeAccountVC = storyboard.instantiateViewController(withIdentifier: "PermissionVC") as?  PermissionVC{
            
            let navigationController = UINavigationController(rootViewController: removeAccountVC)
            self.view.window?.rootViewController = navigationController
            self.view.window?.makeKeyAndVisible()
            
            
        }
    }
    

}
