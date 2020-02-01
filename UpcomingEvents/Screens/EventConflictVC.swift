//
//  EventConflictVC.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/31/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class EventConflictVC: UIViewController {

    private var event: Event!
    var onDismiss: EmptyCompletion?
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureViewController()
        super.viewDidLoad()
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
        if let onDismiss = onDismiss {
            onDismiss()
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

}
