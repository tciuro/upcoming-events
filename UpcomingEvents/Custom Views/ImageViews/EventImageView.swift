//
//  EventImageView.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/31/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class EventImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shouldDisplayWarning(_ shouldDisplayWarning: Bool) {
        if shouldDisplayWarning {
            image = Images.warningImage
            tintColor = .systemYellow
        } else {
            image = Images.calendarImage
            tintColor = .systemPink
        }
    }
    
    private func configure() {
        image = nil
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
