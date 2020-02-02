//
//  DailyEventsVC.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class DailyEventsVC: UIViewController {
    
    private var tableView: UITableView!
    private var localeChangeObserver: NSObjectProtocol!
    
    var onDismiss: EmptyCompletion?
    var eventDays = [Day]() {
        didSet {
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }

    init(eventDays: [Day] = []) {
        self.eventDays = eventDays
        super.init(nibName: nil, bundle: nil)
    }
    
    init(day: Day, selectedEvent: Event) {
        let filteredDay = day.copy() as! Day
        filteredDay.filterLeavingConflicts(event: selectedEvent)
        self.eventDays = [filteredDay]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh() {
        tableView.reloadData()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        self.title = "Upcoming Events"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Listen for locale changes
        let center = NotificationCenter.default
        let mainQueue = OperationQueue.main
        self.localeChangeObserver = center.addObserver(forName: NSLocale.currentLocaleDidChangeNotification, object: nil, queue: mainQueue) { _ in
            self.tableView.reloadData()
        }

    }
    
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.rowHeight = 80.0
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseID)

        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

extension DailyEventsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let day = eventDays[indexPath.section]
        let event = day.events[indexPath.row]
        let destinationVC = EventConflictVC(day: day, event: event)
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

extension DailyEventsVC: UITableViewDataSource {
    
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
            let isConflict = day.isFiltered ? true : day.isEventInConflict(event)
            let showDisclosureIfConflict = day.isFiltered ? false : true
            eventCell.set(event: event, isConflict: isConflict, showDisclosureIfConflict: showDisclosureIfConflict)
        }
        
        return cell
    }

}

extension DailyEventsVC: UpcomingEventsUIHandling {
    
    func setEventDays(_ days: [Day]) {
        self.eventDays = days
    }
    
}
