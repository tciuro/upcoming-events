//
//  Date+Extension.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

extension Date {
    
    /// Returns the start of the current day
    var startOfDay: Date {
        return Calendar.autoupdatingCurrent.startOfDay(for: self)
    }
    
    /// Returns the end of the current day.
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.autoupdatingCurrent.date(byAdding: components, to: startOfDay)!
    }
    
    /// Returns the current date and time according to the current timezone.
    var localDate: String {
        let dateFormatter = EventUtilities.dateFormatter
        var format = "E, d MMM yyyy h:mm a"
        
        if EventUtilities.isDateFormatIn24Hours() {
            format = "E, d MMM yyyy HH:mm"
        }
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    /// Returns an abbreviated date string (i.e. November 10, 2018)
    var abbreviatedDayTitle: String {
        let dateFormatter = EventUtilities.dateFormatter
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: self)
    }
    
    /// Returns an abbreviated time string (i.e. 6:00 PM or 18:00), honoring the 24-hour setting of the device. It doesn't work on the simulator.
    var abbreviatedTimeTitle: String {
        let dateFormatter = EventUtilities.dateFormatter
        var format = "h:mm a"
        
        if EventUtilities.isDateFormatIn24Hours() {
            format = "HH:mm"
        }
        
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }

}
