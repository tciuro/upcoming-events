//
//  FileEventDataService.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

class FileEventDataService {
    
    private var events: [Event]!
    private let url: URL
    private let dateFormatter = DateFormatter()
    
    /// Obtain a list of unique dates. It specifies the year, month and day.
    private lazy var distinctDates: [Date] = {
        let calendar = Calendar.current
        let startDates: [Date] = events.map { event in
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: event.start)
            let date = calendar.date(from: dateComponents)
            return date ?? nil
        }.compactMap { $0 }
        return Array(Set<Date>(startDates))
    }()
    
    init(at url: URL) {
        self.url = url
    }

    func loadEvents(completion: @escaping EmptyCompletion) {
        DispatchQueue.global(qos: .default).async {
            guard let fileContents = try? Data(contentsOf: self.url),
                let json = try? JSONSerialization.jsonObject(with: fileContents,options: []) as? [[String: String]] else { return completion() }
            
            // Date has the following format: November 10, 2018 6:00 PM
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
            
            self.events = json.map { eventInfo in
                return EventUtilities.convertedEvent(from: eventInfo, dateFormatter: dateFormatter)
            }
            .compactMap { $0 }
            
            // We wait half second to show the activity indicator.
            // Needed? Not at all. I just want to make sure we see the indicator on faster phones ;-)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                completion()
            }
        }
    }

}

extension FileEventDataService: EventDataProviding {
    
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
    
    func getEventsGroupedByDay() -> [Day] {
        let distictDates = getDistinctEventDates().sorted()
        
        let days = distictDates.map { date -> Day? in
            let events = getEvents(on: date)
            return events.isEmpty ? nil : Day(date: date, events: events)
        }.compactMap { $0 }
        
        return days
    }

}
