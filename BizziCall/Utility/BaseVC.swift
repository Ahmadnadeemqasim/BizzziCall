//
//  BaseVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/30/24.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar("Status")
        // Do any additional setup after loading the view.
    }
    

    
    open func setupNavigationBar(_ labelTitle: String) {
        // Set the navigation bar background color if needed
        navigationController?.navigationBar.barTintColor = .white
        
        // Set the navigation bar title view with logo
        let logo = UIImage(named: "splashIcon") // Replace "logo" with the name of your image asset
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        // Set the frame of the imageView
        let height: CGFloat = 40 // Adjust the height as needed
        let width = height * (logo?.size.width ?? 1) / (logo?.size.height ?? 1)
        imageView.frame = CGRect(x: .greatestFiniteMagnitude, y: 0, width: width, height: height)
        
        navigationItem.titleView = imageView
        
        // Create the custom left bar button item
        let leftButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40)) // Adjust the width and height as needed
        
        let buttonImage = UIImage(named: "menu") // Replace with your image name
        let buttonImageView = UIImageView(image: buttonImage)
        buttonImageView.contentMode = .scaleAspectFit
        buttonImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let buttonLabel = UILabel()
        buttonLabel.text = "Label"
        buttonLabel.font = UIFont.systemFont(ofSize: 16)
        buttonLabel.frame = CGRect(x: 35, y: 0, width: 65, height: 30)
        
        leftButtonView.addSubview(buttonImageView)
        leftButtonView.addSubview(buttonLabel)
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftButtonView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    
//    func setupNavigationBar() {
//        // Set navigation bar title
//        //        self.title = "Status"
//        
//        // Create menu button
//        let menuButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(menuButtonTapped))
//        menuButton.setBackgroundImage(UIImage(named: "menu"), for: .normal, barMetrics: .default)
//        self.navigationItem.leftBarButtonItem = menuButton
//        
//        // Create logo button (using a custom view for the logo)
//        let logoImage = UIImage(named: "splashIcon") // Make sure you have a logo image added in your assets
//        let logoImageView = UIImageView(image: logoImage)
//        let logoButton = UIBarButtonItem(customView: logoImageView)
//        self.navigationItem.rightBarButtonItem = logoButton
//    }
//    
//    func addSeparatorLine() {
//        let separator = UIView()
//        separator.backgroundColor = UIColor.lightGray
//        separator.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(separator)
//        
//        NSLayoutConstraint.activate([
//            separator.heightAnchor.constraint(equalToConstant: 1),
//            separator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            separator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            separator.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
//        ])
//    }

}


