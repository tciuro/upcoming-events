//
//  UIViewController+Extension.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/31/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    /// Displays a loading view with an animated activity indicator.
    func showLoadingView() -> UIView {
        let containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0.0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        return containerView
    }
    
    /// Hides the loading view.
    /// - Parameter view: the loading view to be hidden.
    func hideLoadingView(_ view: UIView) {
        DispatchQueue.main.async {
            view.removeFromSuperview()
        }
    }
    
    /// Adds a child view controller to a container view and performs all required relations between them.
    /// - Parameters:
    ///   - childVC: the child view controller.
    ///   - containerView: the container view to host the child view controller.
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
}
