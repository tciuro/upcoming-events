//
//  EventDataProvider.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

final class EventDataProvider {
    
    private var fileEventDataProvider: FileEventDataProvider!
    
    init(fileEventURL url: URL) {
        self.fileEventDataProvider = FileEventDataProvider(at: url)
    }
    
}

extension EventDataProvider: EventProviding {
    
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
