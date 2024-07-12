//
//  OutGoingCallVC.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/29/24.
//

import UIKit

class OutGoingCallVC: UIViewController {
    
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var lblCallerNumber: UILabel!
    @IBOutlet weak var lblCallerName: UILabel!
    @IBOutlet weak var lblAvailbleTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnYesTapped(_ sender: UIButton){
        
    }
    @IBAction func btnNoTapped(_ sender: UIButton){
        
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
