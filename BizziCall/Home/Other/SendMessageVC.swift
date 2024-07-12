//
//  SendMessageVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/29/24.
//

import UIKit

class SendMessageVC: UIViewController {

    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var btnSendMessage: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendMessageTapped(_ sender: UIButton){
        
    }
    @IBAction func btnMenuTapped(_ sender: UIButton){
        print("---------Menu Button Tapped-------------")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        if let drawerVC = storyboard.instantiateViewController(withIdentifier: "DrawerTVC") as? DrawerTVC {
            drawerVC.modalTransitionStyle = .partialCurl
            //                        self.show(drawerVC, sender: self)
            
            self.navigationController?.pushViewController(drawerVC, animated: true)
        }
    }
}
