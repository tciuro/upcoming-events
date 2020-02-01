//
//  EventDataProvider.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

final class EventDataProvider {
    
    private var _fileEventDataProvider: FileEventDataProvider
    var fileEventDataProvider: FileEventDataProvider {
        get { return _fileEventDataProvider }
    }

    init(eventDataProvider: FileEventDataProvider) {
        self._fileEventDataProvider = eventDataProvider
    }
    
}

extension EventDataProvider: EventDataProviding {
    
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
