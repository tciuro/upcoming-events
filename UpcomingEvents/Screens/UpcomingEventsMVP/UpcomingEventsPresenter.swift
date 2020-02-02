//
//  UpcomingEventsPresenter.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 2/1/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class UpcomingEventsPresenter  {
    
    private weak var delegate: UpcomingEventsUIHandling?
    private var eventDataService: EventDataService

    init(delegate: UpcomingEventsUIHandling, eventDataService: EventDataService) {
        self.delegate = delegate
        self.eventDataService = eventDataService
    }
    
    /// Loads the events asynchronously. The completion handler is dispatched on the main queue.
    /// - Parameter completion: the completion handler invoked upon completion.
    func loadEvents(completion: @escaping EmptyCompletion) {
        eventDataService.fileEventDataService.loadEvents(completion: completion)
    }
    
    /// Returns a list of unique days, each containing one or more events. The list is sorted chronologically.
    func getEventsGroupedByDay() {
        let days = eventDataService.fileEventDataService.getEventsGroupedByDay()
        delegate?.setEventDays(days)
    }
    
}
