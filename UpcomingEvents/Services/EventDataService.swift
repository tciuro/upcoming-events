//
//  EventDataService.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

final class EventDataService {
    
    private var _fileEventDataService: FileEventDataService
    var fileEventDataService: FileEventDataService {
        get { return _fileEventDataService }
    }

    init(eventDataService: FileEventDataService) {
        self._fileEventDataService = eventDataService
    }
    
}

extension EventDataService: EventDataServicing {
    
    func getDistinctEventDates() -> [Date] {
        return fileEventDataService.getDistinctEventDates()
    }
    
    func getEvents(on date: Date) -> [Event] {
        return fileEventDataService.getEvents(on: date)
    }
    
    func getEventsGroupedByDay() -> [Day] {
        return fileEventDataService.getEventsGroupedByDay()
    }
    
}
