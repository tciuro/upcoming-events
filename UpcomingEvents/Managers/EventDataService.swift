//
//  EventDataService.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

final class EventDataService {
    
    private var _fileEventDataProvider: FileEventDataService
    var fileEventDataProvider: FileEventDataService {
        get { return _fileEventDataProvider }
    }

    init(eventDataProvider: FileEventDataService) {
        self._fileEventDataProvider = eventDataProvider
    }
    
}

extension EventDataService: EventDataProviding {
    
    func getDistinctEventDates() -> [Date] {
        return fileEventDataProvider.getDistinctEventDates()
    }
    
    func getEvents(on date: Date) -> [Event] {
        return fileEventDataProvider.getEvents(on: date)
    }
    
    func getEventsGroupedByDay() -> [Day] {
        return fileEventDataProvider.getEventsGroupedByDay()
    }
    
}
