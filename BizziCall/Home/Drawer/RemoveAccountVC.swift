//
//  RemoveAccountVC.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 7/13/24.
//

import UIKit

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
    }
    
}
