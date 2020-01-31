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
    private var eventDays: [Day]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }

    init(eventDataProvider: EventDataProvider) {
        self.eventDays = eventDataProvider.getEventsGroupedByDay()
        super.init(nibName: nil, bundle: nil)
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
    
}

extension UpcomingEventsVC: UITableViewDelegate {
    
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
            eventCell.set(event: event, isConflict: isConflict)
        }
        
        return cell
    }

}
