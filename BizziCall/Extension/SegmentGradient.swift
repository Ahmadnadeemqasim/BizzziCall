//
//  SegmentGradient.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 6/28/24.
//
import UIKit

class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    init() {
        super.init(frame: .zero)
        setupGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradientLayer()
    }
    
    private func setupGradientLayer() {
        gradientLayer.colors = [UIColor.gradientEnd.cgColor, UIColor.gradientStart.cgColor] // Adjust colors as needed
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

import UIKit

class GradientSegmentedControl: UISegmentedControl {
    
    private let gradientView = GradientView()
    
    override init(items: [Any]?) {
        super.init(items: items)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(gradientView)
        sendSubviewToBack(gradientView)
        addTarget(self, action: #selector(updateGradientPosition), for: .valueChanged)
        updateGradientPosition()
    }
    
    @objc private func updateGradientPosition() {
        guard numberOfSegments > 0 else { return }
        let segmentWidth = bounds.width / CGFloat(numberOfSegments)
        let segmentFrame = CGRect(x: segmentWidth * CGFloat(selectedSegmentIndex), y: 0, width: segmentWidth, height: bounds.height)
        gradientView.frame = segmentFrame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientPosition()
    }
}
