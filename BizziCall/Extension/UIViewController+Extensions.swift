//
//  UIViewController+Extensions.swift
//  Sidemenutest
//
//  Created by Ahmad Qasim on 12/06/2024.
//

import Foundation
import UIKit

//extension UIViewController {
//    
////    func presentSideMenu() {
////        // Add side menu drawer presentation animation here
////    }
////    
////    func dismissSideMenu() {
////        // Add side menu drawer dismissal animation here
////    }
//    
//    func presentSideMenu(sideMenu: UIViewController) {
//            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//            
//            // Set the initial frame of the side menu
//            sideMenu.view.frame = CGRect(x: -window.frame.width, y: 0, width: window.frame.width * 0.8, height: window.frame.height)
//            
//            // Add the side menu view to the window
//            window.addSubview(sideMenu.view)
//            self.addChild(sideMenu)
//            sideMenu.didMove(toParent: self)
//            
//            // Animate the side menu into view
//            UIView.animate(withDuration: 0.3, animations: {
//                sideMenu.view.frame = CGRect(x: 0, y: 0, width: window.frame.width * 0.8, height: window.frame.height)
//            })
//        }
//        
//        func dismissSideMenu(sideMenu: UIViewController) {
//            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//            
//            // Animate the side menu out of view
//            UIView.animate(withDuration: 0.3, animations: {
//                sideMenu.view.frame = CGRect(x: -window.frame.width, y: 0, width: window.frame.width * 0.8, height: window.frame.height)
//            }, completion: { _ in
//                // Remove the side menu view from the window
//                sideMenu.view.removeFromSuperview()
//                sideMenu.removeFromParent()
//            })
//        }
//}

//
//import UIKit
//
//extension UIViewController {
//    
//    func presentSideMenu(sideMenu: UIViewController) {
//        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//        
//        // Set the initial frame of the side menu
//        sideMenu.view.frame = CGRect(x: -window.frame.width, y: 0, width: window.frame.width * 0.8, height: window.frame.height)
//        
//        // Add the side menu view to the window
//        window.addSubview(sideMenu.view)
//        self.addChild(sideMenu)
//        sideMenu.didMove(toParent: self)
//        
//        // Add a transparent view to detect taps outside the menu
//        let overlayView = UIView(frame: window.frame)
//        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        overlayView.tag = 99
//        window.addSubview(overlayView)
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlayView))
//        overlayView.addGestureRecognizer(tapGesture)
//        
//        // Animate the side menu into view
//        UIView.animate(withDuration: 0.3, animations: {
//            sideMenu.view.frame = CGRect(x: 0, y: 0, width: window.frame.width * 0.8, height: window.frame.height)
//        })
//    }
//    
//    func dismissSideMenu(sideMenu: UIViewController) {
//        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
//        
//        // Animate the side menu out of view
//        UIView.animate(withDuration: 0.3, animations: {
//            sideMenu.view.frame = CGRect(x: -window.frame.width, y: 0, width: window.frame.width * 0.8, height: window.frame.height)
//        }, completion: { _ in
//            // Remove the side menu view from the window
//            sideMenu.view.removeFromSuperview()
//            sideMenu.removeFromParent()
//            
//            // Remove the overlay view
//            window.viewWithTag(99)?.removeFromSuperview()
//        })
//    }
//    
//    @objc private func dismissOverlayView() {
//        if let sideMenu = self.children.first(where: { $0 is SideMenuViewController }) as? SideMenuViewController {
//            dismissSideMenu(sideMenu: sideMenu)
//        }
//    }
//}

import UIKit

extension UIViewController {
    
    
    
    func presentSideMenu(sideMenu: UIViewController) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        // Set the initial frame of the side menu
        sideMenu.view.frame = CGRect(x: -window.frame.width, y: 0, width: window.frame.width * 0.8, height: window.frame.height)
        
        // Add the side menu view to the window
        window.addSubview(sideMenu.view)
        self.addChild(sideMenu)
        sideMenu.didMove(toParent: self)
        
        // Add a transparent view to detect taps outside the menu
        let overlayView = UIView(frame: window.frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.tag = 99
        window.addSubview(overlayView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOverlayView))
        overlayView.addGestureRecognizer(tapGesture)
        
        // Animate the side menu into view
        UIView.animate(withDuration: 0.3, animations: {
            sideMenu.view.frame = CGRect(x: 0, y: 0, width: window.frame.width * 0.8, height: window.frame.height)
        })
    }
    
    func dismissSideMenu(sideMenu: UIViewController) {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        // Animate the side menu out of view
        UIView.animate(withDuration: 0.3, animations: {
            sideMenu.view.frame = CGRect(x: -window.frame.width, y: 0, width: window.frame.width * 0.8, height: window.frame.height)
        }, completion: { _ in
            // Remove the side menu view from the window
            sideMenu.view.removeFromSuperview()
            sideMenu.removeFromParent()
            
            // Remove the overlay view
            window.viewWithTag(99)?.removeFromSuperview()
        })
    }
    
    @objc private func dismissOverlayView() {
        if let sideMenu = self.children.first(where: { $0 is DrawerTVC }) as? DrawerTVC {
            dismissSideMenu(sideMenu: sideMenu)
        }
    }
}
