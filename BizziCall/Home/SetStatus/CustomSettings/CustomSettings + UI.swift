//
//  CustomSettings + UI.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 6/29/24.
//

import Foundation
import UIKit

extension CustomSettingsVC {
    
    func setupTextField() {
        txtFieldStatus.isEnabled = false
        txtFieldToHour.borderStyle = .roundedRect
        txtFieldToHour.layer.cornerRadius = 3.0
        btnDone.layer.cornerRadius = 7.0
        txtFieldFromHour.borderStyle = .roundedRect
        txtFieldFromHour.layer.cornerRadius = 3.0
        txtFieldToHour.layer.borderWidth = 1
        txtFieldFromHour.layer.borderWidth = 1
        txtFieldFromHour.layer.borderColor = UIColor.gradientEnd.cgColor
        txtFieldFromMinutes.layer.borderColor = UIColor.gradientEnd.cgColor
        txtFieldToHour.layer.borderColor = UIColor.gradientEnd.cgColor
        txtFieldToMinutes.layer.borderColor = UIColor.gradientEnd.cgColor
        
    }
    
    func customizeSegmentedControl(segmentedControl: UISegmentedControl) {
        // Set the text color for the selected segment
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        // Set the text color for the normal (unselected) segments
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
    }
    
    func populateFromSectionWithCurrentTime() {
        let currentDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)
        
        let isPM = hour >= 12
        let hourIn12 = hour % 12 == 0 ? 12 : hour % 12
        
        txtFieldFromHour.text = String(format: "%02d", hourIn12)
        txtFieldFromMinutes.text = String(format: "%02d", minute)
        sgbarFromTime.selectedSegmentIndex = isPM ? 1 : 0
        txtFieldFromHour.isUserInteractionEnabled =  false
        txtFieldFromMinutes.isUserInteractionEnabled =  false
        sgbarFromTime.isUserInteractionEnabled =  false
    }
    
}
