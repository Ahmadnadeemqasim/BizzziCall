//
//  GradientButton.swift
//  BizzCall
//
//  Created by Ahmad Qasim on 5/27/24.
//

import Foundation

import UIKit

@IBDesignable
class GradientButton: UIButton {
    
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable var startColor: UIColor = UIColor.clear {
        didSet {
            updateGradientColors()
        }
    }
    
    @IBInspectable var endColor: UIColor = UIColor.clear {
        didSet {
            updateGradientColors()
        }
    }
    
    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            updateGradientPoints()
        }
    }
    
    @IBInspectable var startPointY: CGFloat = 0 {
        didSet {
            updateGradientPoints()
        }
    }
    
    @IBInspectable var endPointX: CGFloat = 1 {
        didSet {
            updateGradientPoints()
        }
    }
    
    @IBInspectable var endPointY: CGFloat = 1 {
        didSet {
            updateGradientPoints()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    private func updateGradientPoints() {
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
    }
    
    
    
//    @IBInspectable var cornerRadius: CGFloat = 0.0 {
//        didSet {
//            self.layer.cornerRadius = cornerRadius
//            self.clipsToBounds = true
//        }
//    }
//    
//    override public func layoutSublayers(of layer: CALayer) {
//        super.layoutSublayers(of: layer)
//        gradientLayer.frame = bounds
//    }
//    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
}
