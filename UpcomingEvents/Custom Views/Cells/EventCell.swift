//
//  EventCell.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/31/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    static let reuseID = "EventCell"
    
    private let eventImageView = EventImageView(frame: .zero)
    private let titleLabel = TitleLabel(textAlignment: .left, fontSize: 18.0)
    private let timeRangeLabel = SecondaryTitleLabel(fontSize: 15.0)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .none
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(event: Event, isConflict: Bool, showDisclosureIfConflict: Bool) {
        eventImageView.shouldDisplayWarning(isConflict)
        titleLabel.text = event.title
        timeRangeLabel.text = "\(event.start.abbreviatedTimeTitle) - \(event.end.abbreviatedTimeTitle)"
        accessoryType = isConflict && showDisclosureIfConflict ? .disclosureIndicator : .none
    }
    
    private func addSubviews() {
        addSubview(eventImageView)
        addSubview(titleLabel)
        addSubview(timeRangeLabel)
    }
    
    private func configureLayout() {
        
        let padding: CGFloat = 12.0
        let imageSize: CGFloat = 40.0
        
        let constraints = [
            eventImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            eventImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            eventImageView.heightAnchor.constraint(equalToConstant: imageSize),
            eventImageView.widthAnchor.constraint(equalToConstant: imageSize),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            titleLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            timeRangeLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: padding),
            timeRangeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            timeRangeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0),
            timeRangeLabel.heightAnchor.constraint(equalToConstant: 20.0)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
