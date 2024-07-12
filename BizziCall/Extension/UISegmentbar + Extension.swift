//
//  UISegmentbar + Extension.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 6/27/24.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor ?? UIColor.clear), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: tintColor), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    

}
