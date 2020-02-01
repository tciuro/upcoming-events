//
//  UpcomingEventsVC.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class UpcomingEventsVC: UIViewController {
    
    private var tableView: UITableView!
    private var eventDays = [Day]()
    private var presenter: UpcomingEventsPresenter!

    var onDismiss: EmptyCompletion?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureDataSource()
    }

    init(eventDataProvider: EventDataProvider) {
        super.init(nibName: nil, bundle: nil)
        presenter = UpcomingEventsPresenter(ui: self, eventDataProvider: eventDataProvider)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Upcoming Events"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.frame = view.bounds
        tableView.rowHeight = 80.0
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseID)

        view.addSubview(tableView)
    }
    
    private func configureDataSource() {
        // Hide the table view
        self.tableView.alpha = 0.0;

        // Show the activity indicator
        let loadingView = showLoadingView()
        
        // Load the events from the file
        presenter.loadEvents { [weak self] in
            guard let self = self else { return }
            
            // We can safely remove the loading view
            self.hideLoadingView(loadingView)
            
            // Build the event groups
            self.presenter.getEventsGroupedByDay()
            
            // Reload the table view
            self.tableView.reloadData()

            // Gently display it
            UIView.animate(withDuration: 0.5) {
                self.tableView.alpha = 1.0
            }
        }
    }
    
    private func deselectTableView() {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
        if let onDismiss = onDismiss {
            onDismiss()
        }
    }
    
}

extension UpcomingEventsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = eventDays[indexPath.section]
        let event = day.events[indexPath.row]
        let destinationVC = EventConflictVC(event: event)
        destinationVC.onDismiss = {
            self.deselectTableView()
        }
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let day = eventDays[indexPath.section]
        let event = day.events[indexPath.row]
        guard event.getConflicts() != nil else { return false }
        return true
    }

}

extension UpcomingEventsVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventDays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDays[section].events.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventDays[section].date.abbreviatedDayTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseID, for: indexPath)
        
        if let eventCell = cell as? EventCell {
            let day = eventDays[indexPath.section]
            let event = day.events[indexPath.row]
            let isConflict = day.isEventInConflict(event)
            eventCell.set(event: event, isConflict: isConflict, showDisclosureIfConflict: true)
        }
        
        return cell
    }

}

extension UpcomingEventsVC: UpcomingEventsUIHandling {
    
    func setEventDays(_ days: [Day]) {
        self.eventDays = days
    }
    
}
