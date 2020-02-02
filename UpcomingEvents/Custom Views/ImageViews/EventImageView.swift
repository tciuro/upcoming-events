//
//  EventImageView.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/31/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

enum EventImageType {
    case warning
    case calendar
}

class EventImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Set the type of image.
    /// - Parameter type: EventImageType: .warning, .calendar
    func setImage(type: EventImageType) {
        switch type {
        case .warning:
            image = Images.warningImage
            tintColor = .systemYellow
        case .calendar:
            image = Images.calendarImage
            tintColor = .systemPink
        }
    }
    
    private func configure() {
        image = nil
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
