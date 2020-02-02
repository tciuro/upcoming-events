//
//  UpcomingEventsPresenter.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 2/1/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class UpcomingEventsPresenter  {
    
    private weak var ui: UpcomingEventsUIHandling?
    private var eventDataService: EventDataService

    init(ui: UpcomingEventsUIHandling, eventDataService: EventDataService) {
        self.ui = ui
        self.eventDataService = eventDataService
    }
    
    func loadEvents(completion: @escaping EmptyCompletion) {
        eventDataService.fileEventDataService.loadEvents(completion: completion)
    }
    
    func getEventsGroupedByDay() {
        let days = eventDataService.fileEventDataService.getEventsGroupedByDay()
        ui?.setEventDays(days)
    }
    
}
