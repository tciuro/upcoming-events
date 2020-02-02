//
//  EventUtilities.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

struct EventUtilities {
    
    /// Main date formatter.
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter
    }()
    
    /// Whether the device is configured to display the time in 24-hour format. On the simulator, this method always returns false.
    static func isDateFormatIn24Hours() -> Bool {
        let locale = Locale.autoupdatingCurrent
        if let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)  {
            if dateFormat.contains("H") || dateFormat.contains("k") {
                return true
            }
        }
        return false
    }
    
    /// Given a JSON object, attempt to instantiate an Event.
    /// - Parameters:
    ///   - jsonEvent: the JSON object to be converted.
    ///   - dateFormatter: the date formatter used to transform the date string into a Date.
    static func convertedEvent(from jsonEvent: [String: String], dateFormatter: DateFormatter) -> Event? {
        if let title = jsonEvent["title"],
            let start = dateFromJSONEventDateString(jsonEvent["start"], dateFormatter: dateFormatter),
            let end = dateFromJSONEventDateString(jsonEvent["end"], dateFormatter: dateFormatter) {
            return Event(title: title, start: start, end: end)
        }
        return nil
    }
    
    /// Transform a date string into a Date.
    /// - Parameters:
    ///   - dateString: the date string to be transformed.
    ///   - dateFormatter: the date formatter used to transform the date string.
    static func dateFromJSONEventDateString(_ dateString: String?, dateFormatter: DateFormatter) -> Date? {
        guard let dateString = dateString, let date = dateFormatter.date(from: dateString) else { return nil }
        return date
    }
    
}
