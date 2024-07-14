//
//  HalfPresentationVC.swift
//  BizziCall
//
//  Created by Ahmad Qasim on 7/14/24.
//

import Foundation

import UIKit

class HalfSizeTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class HalfSizePresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return CGRect()
        }
        let containerBounds = containerView.bounds
        let height = containerBounds.height / 2
        return CGRect(x: 0, y: containerBounds.height - height, width: containerBounds.width, height: height)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView = containerView else { return }
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmingView.alpha = 0
        containerView.insertSubview(dimmingView, at: 0)
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            dimmingView.alpha = 1
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let containerView = containerView else { return }
        let dimmingView = containerView.subviews.first
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            dimmingView?.alpha = 0
        }, completion: { _ in
            dimmingView?.removeFromSuperview()
        })
    }
}
