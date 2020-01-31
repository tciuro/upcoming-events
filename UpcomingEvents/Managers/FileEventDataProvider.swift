//
//  FileEventDataProvider.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

class FileEventDataProvider {
    
    private var events: [Event]!
    private let url: URL
    private let dateFormatter = DateFormatter()
    
    private lazy var distinctDates: [Date] = {
        let calendar = Calendar.current
        let startDates: [Date] = events.map { event in
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: event.start)
            let date = calendar.date(from: dateComponents)
            return date ?? nil
        }.compactMap { $0 }
        return Array(Set<Date>(startDates)).sorted()
    }()
    
    init?(at url: URL) {
        self.url = url
        if !loadEvents() { return nil }
    }

}

extension FileEventDataProvider: EventProviding {
    
    func getDistinctEventDates() -> [Date] {
        return distinctDates
    }
    
    func getEvents(on date: Date) -> [Event] {
        return events.filter { event -> Bool in
            let eventDate = event.start
            let startOfDay = eventDate.startOfDay
            let endOfDay = eventDate.endOfDay
            let range = startOfDay...endOfDay
            return range.contains(date)
        }
    }

}

private extension FileEventDataProvider {
    
    func loadEvents() -> Bool {
        guard  let fileContents = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: fileContents, options: []) as? [[String: String]] else { return false }
        
        events = json.map { eventInfo in
            return EventUtilities.convertedEvent(from: eventInfo)
        }.compactMap { $0 }
        
        return true
    }
    

}
