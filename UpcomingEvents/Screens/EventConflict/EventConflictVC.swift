//
//  EventConflictVC.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/31/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class EventConflictVC: UIViewController {
    
    private let warningImageView = EventImageView(frame: .zero)
    private let titleLabel = TitleLabel(textAlignment: .left, fontSize: 18.0)
    private let timeRangeLabel = SecondaryTitleLabel(fontSize: 15.0)

    private let dailyEventsContainerView = UIView()
    private var dailyEventsVC: DailyEventsVC!

    private var localeChangeObserver: NSObjectProtocol!

    private var day: Day!
    private var event: Event!

    var onDismiss: EmptyCompletion?
    
    init(day: Day, event: Event) {
        self.day = day
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureViewController()
        configureHeader()
        configureLayoutUI()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func refresh() {
        self.refreshTimeRangeLabel()
        self.dailyEventsVC.refresh()
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
        if let onDismiss = onDismiss {
            onDismiss()
        }
    }
    
    private func configureViewController() {
        self.title = "Event Conflict"
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        // Listen for locale changes
        let center = NotificationCenter.default
        let mainQueue = OperationQueue.main
        self.localeChangeObserver = center.addObserver(forName: NSLocale.currentLocaleDidChangeNotification, object: nil, queue: mainQueue) { _ in
            self.refresh()
        }
    }
    
    private func configureHeader() {
        view.addSubview(warningImageView)
        view.addSubview(titleLabel)
        view.addSubview(timeRangeLabel)

        warningImageView.setImage(type: .warning)
        titleLabel.text = event.title
        refreshTimeRangeLabel()
        
        let padding: CGFloat = 12.0
        let imageSize: CGFloat = 60.0
        
        NSLayoutConstraint.activate([
            warningImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            warningImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            warningImageView.heightAnchor.constraint(equalToConstant: imageSize),
            warningImageView.widthAnchor.constraint(equalToConstant: imageSize),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            titleLabel.leadingAnchor.constraint(equalTo: warningImageView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            timeRangeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -5.0),
            timeRangeLabel.leadingAnchor.constraint(equalTo: warningImageView.trailingAnchor, constant: padding),
            timeRangeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
    
    private func configureLayoutUI() {
        view.addSubview(dailyEventsContainerView)
        
        dailyEventsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dailyEventsContainerView.topAnchor.constraint(equalTo: timeRangeLabel.bottomAnchor, constant: 10.0),
            dailyEventsContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dailyEventsContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dailyEventsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        dailyEventsVC = DailyEventsVC(day: day, selectedEvent: event)
        add(childVC: dailyEventsVC, to: dailyEventsContainerView)
    }

    private func refreshTimeRangeLabel() {
        timeRangeLabel.text = "\(event.start.abbreviatedTimeTitle) - \(event.end.abbreviatedTimeTitle)"
    }

}
