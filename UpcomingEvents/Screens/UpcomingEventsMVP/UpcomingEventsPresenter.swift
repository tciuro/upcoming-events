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
    private var eventDataProvider: EventDataProvider

    init(ui: UpcomingEventsUIHandling, eventDataProvider: EventDataProvider) {
        self.ui = ui
        self.eventDataProvider = eventDataProvider
    }
    
    func loadEvents(completion: @escaping EmptyCompletion) {
        eventDataProvider.fileEventDataProvider.loadEvents(completion: completion)
    }
    
    func getEventsGroupedByDay() {
        let days = eventDataProvider.fileEventDataProvider.getEventsGroupedByDay()
        ui?.setEventDays(days)
    }
    
}
