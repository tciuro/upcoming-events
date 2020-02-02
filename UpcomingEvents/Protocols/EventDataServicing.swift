//
//  EventDataServicing.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

protocol EventDataServicing {
    
    /// Get all unique dates without the time components (e.g. November 10, 2018).
    func getDistinctEventDates() -> [Date]
    
    /// Get all events on a specific day.
    /// - Parameter date: the date from which to obtain the list of events.
    func getEvents(on date: Date) -> [Event]
    
    /// Get the list of events grouped by day.
    func getEventsGroupedByDay() -> [Day]
    
}
