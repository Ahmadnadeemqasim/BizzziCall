//
//  File.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/30/24.
//

import Foundation

import UIKit

@IBDesignable
class ShadowButton: UIButton {
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 1) {
        didSet {
            updateShadow()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 4 {
        didSet {
            updateShadow()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
    }
    
    private func setupShadow() {
        layer.masksToBounds = false
        updateShadow()
    }
    
    private func updateShadow() {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure the shadow properties are updated if the button's layout changes
        updateShadow()
    }
}
