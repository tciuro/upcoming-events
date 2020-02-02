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
    private var tableView: UITableView!
    private var localeChangeObserver: NSObjectProtocol!

    private var event: Event!
    private var conflicts: [Event]

    var onDismiss: EmptyCompletion?
    
    init(event: Event) {
        self.event = event
        self.conflicts = event.getConflicts() ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureViewController()
        configureHeader()
        configureTableView()
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
        self.title = "Event Info"
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        // Listen for locale changes
        let center = NotificationCenter.default
        let mainQueue = OperationQueue.main
        self.localeChangeObserver = center.addObserver(forName: NSLocale.currentLocaleDidChangeNotification, object: nil, queue: mainQueue) { _ in
            self.refreshTimeRangeLabel()
            self.tableView.reloadData()
        }
    }
    
    private func configureHeader() {
        view.addSubview(warningImageView)
        view.addSubview(titleLabel)
        view.addSubview(timeRangeLabel)

        warningImageView.shouldDisplayWarning(true)
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
    
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 80.0
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.reuseID)
        
        let padding: CGFloat = 12.0
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo:timeRangeLabel.bottomAnchor, constant: padding),
            tableView.leftAnchor.constraint(equalTo:view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo:view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        ])
    }
    
    private func refreshTimeRangeLabel() {
        timeRangeLabel.text = "\(event.start.abbreviatedTimeTitle) - \(event.end.abbreviatedTimeTitle)"
    }

}

extension EventConflictVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

extension EventConflictVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conflicts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Conflicting Events"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.reuseID, for: indexPath)
        
        if let eventCell = cell as? EventCell {
            eventCell.set(event: conflicts[indexPath.row], isConflict: true, showDisclosureIfConflict: false)
        }
        
        return cell
    }
    
}
