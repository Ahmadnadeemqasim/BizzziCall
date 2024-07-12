//
//  PermissionMAnager.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 7/10/24.
//

import Foundation
import CoreData
import Contacts
import UIKit

class PermissionnManager {
    
    
    static let shared = PermissionnManager()
    
    private init() {}
//    
//        func checkPermissions() {
////            checkContactsPermission()
//        }
//    
//        func checkContactsPermission() {
//            let store = CNContactStore()
//            let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
//    
//            switch authorizationStatus {
//            case .notDetermined:
//                store.requestAccess(for: .contacts) { granted, error in
//                    DispatchQueue.main.async {
//                        if granted {
//                            self.checkOtherPermissions()
//                        } else {
//                            self.showContactsPermissionAlert()
//                        }
//                    }
//                }
//            case .authorized:
//                checkOtherPermissions()
//            case .denied, .restricted:
//                showContactsPermissionAlert()
//            @unknown default:
//                fatalError("Unknown authorization status")
//            }
//        }
//    
//        func checkOtherPermissions() {
//            // Assuming you have more permissions to check
//            // Add more permission checks here if necessary
//            if allPermissionsGranted() {
//                navigateToSignUp()
//            } else {
//                showContactsPermissionAlert()
//            }
//        }
//    
//        func showContactsPermissionAlert() {
//            let alert = UIAlertController(title: "Contacts Permission Required",
//                                          message: "This app needs access to your contacts to function properly. Please grant access in Settings.",
//                                          preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
//                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                    return
//                }
//                if UIApplication.shared.canOpenURL(settingsUrl) {
//                    UIApplication.shared.open(settingsUrl, completionHandler: { _ in
//                        // Optionally, handle completion if needed
//                    })
//                }
//            })
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
//                exit(0) // Close the app if permissions are not granted
//            }))
//            present(alert, animated: true, completion: nil)
//        }
//    
//        func allPermissionsGranted() -> Bool {
//            // Check if all required permissions are granted
//            // Add more checks for other permissions if needed
//            let contactsGranted = CNContactStore.authorizationStatus(for: .contacts) == .authorized
//            // Add more checks for other permissions here
//    
//            return contactsGranted
//        }
//    
//        func navigateToSignUp() {
//            UserDefaults.standard.set(true, forKey: "permissionsGranted")
//            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
//            let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
//            signUpVC.modalTransitionStyle = .crossDissolve
//            signUpVC.modalPresentationStyle = .fullScreen
//            present(signUpVC, animated: true, completion: nil)
//        }
}

