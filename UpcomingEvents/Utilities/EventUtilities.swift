//
//  EventUtilities.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

struct EventUtilities {
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()
    
    static func abbreviatedDayTitle(of date: Date) -> String {
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func convertedEvent(from jsonEvent: [String: String]) -> Event? {
        if let title = jsonEvent["title"],
            let start = dateFromJSONEventDateString(jsonEvent["start"]),
            let end = dateFromJSONEventDateString(jsonEvent["end"]) {
            return Event(title: title, start: start, end: end)
        }
        return nil
    }
    
    static func dateFromJSONEventDateString(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        
        // Date has the following format: November 10, 2018 6:00 PM
        dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
        
        return dateFormatter.date(from: dateString)!
    }
    
}
