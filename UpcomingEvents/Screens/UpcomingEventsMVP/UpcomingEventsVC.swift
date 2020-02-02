//
//  UpcomingEventsVC.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class UpcomingEventsVC: UIViewController {
    
    private let dailyEventsContainerView = UIView()
    private var dailyEventsVC: DailyEventsVC!

    private var eventDays = [Day]()
    private var presenter: UpcomingEventsPresenter!
    private var localeChangeObserver: NSObjectProtocol!
    
    var onDismiss: EmptyCompletion?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureLayoutUI()
        configureDataSource()
    }

    init(eventDataService: EventDataService) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = UpcomingEventsPresenter(delegate: self, eventDataService: eventDataService)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewController() {
        self.title = "Upcoming Events"
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Listen for locale changes
        let center = NotificationCenter.default
        let mainQueue = OperationQueue.main
        self.localeChangeObserver = center.addObserver(forName: NSLocale.currentLocaleDidChangeNotification, object: nil, queue: mainQueue) { _ in
            self.dailyEventsVC.refresh()
        }
    }
    
    private func configureLayoutUI() {
        view.addSubview(dailyEventsContainerView)
        
        dailyEventsContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dailyEventsContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dailyEventsContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dailyEventsContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dailyEventsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        dailyEventsVC = DailyEventsVC()
        add(childVC: dailyEventsVC, to: dailyEventsContainerView)
    }
    
    private func configureDataSource() {
        // Hide the table view
        dailyEventsContainerView.alpha = 0.0;

        // Show the activity indicator
        let loadingView = showLoadingView()
        
        // Load the events from the file
        presenter.loadEvents { [weak self] in
            guard let self = self else { return }
            
            // We can safely remove the loading view
            self.hideLoadingView(loadingView)
            
            // Build the event groups
            self.presenter.getEventsGroupedByDay()

            // Gently display it
            UIView.animate(withDuration: 0.5) {
                self.dailyEventsContainerView.alpha = 1.0
            }
        }
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
        if let onDismiss = onDismiss {
            onDismiss()
        }
    }
    
}

extension UpcomingEventsVC: UpcomingEventsUIHandling {
    
    func setEventDays(_ days: [Day]) {
        dailyEventsVC.eventDays = days
    }
    
}
