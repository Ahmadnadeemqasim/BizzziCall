//
//  HistoryVC + CollectionView.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 6/29/24.
//

import Foundation
import UIKit


extension HistoryVC {
    
    func setupSideMenu() {
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
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadHistory()
        case 1:
            loadNotifications()
        default:
            break
        }
    }
    
    @IBAction func btnMenuTapped(_ sender: UIButton){
        print("---------Menu Button Tapped-------------")
        toggleSideMenu()
    }
    
    func toggleSideMenu() {
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
    
    func customizeSegmentedControl() {
        segmentedControl.removeBorders()
        segmentedControl.layer.borderWidth = 2
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.red], for: .selected)
        
        // Create bottom border
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: segmentedControl.bounds.minX, y: segmentedControl.bounds.maxY - 2, width: segmentedControl.bounds.width / CGFloat(segmentedControl.numberOfSegments), height: 2)
        bottomBorder.backgroundColor = UIColor.red.cgColor
        segmentedControl.layer.addSublayer(bottomBorder)
        
        // Update border on segment change
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
}

extension HistoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let paddingSpace = 10 * (itemsPerRow + 1) // Interitem spacing + section insets
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredAppIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvNotification.dequeueReusableCell(withReuseIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.imgSocialAppIcon.image = UIImage(named: filteredAppIcons[indexPath.row])
        return cell
    }
    
    
}

