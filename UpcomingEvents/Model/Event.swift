//
//  Event.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

class Event: Codable, Hashable {
    
    let title: String
    let start: Date
    let end: Date
    
    private var eventConflicts: [Event]?
    
    init(title: String, start: Date, end: Date) {
        self.title = title
        self.start = start
        self.end = end
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.title == rhs.title
            && lhs.start == rhs.start
            && lhs.end == rhs.end
    }
    
    func hash(into hasher: inout Hasher) {
        title.hash(into: &hasher)
        start.hash(into: &hasher)
        end.hash(into: &hasher)
    }
    
    /// Adds an event to the conflicts list.
    /// - Parameter event: the event that conflicts with the current one.
    func addConflict(event: Event) {
        if eventConflicts == nil {
            eventConflicts = []
        }
        eventConflicts?.append(event)
    }
    
    /// Retrieve the list of conflicts.
    func getConflicts() -> [Event]? {
        return eventConflicts
    }
}

extension Event: CustomStringConvertible {
    var description: String {
        return """
        \nEvent: \(self.title)
        Start: \(self.start.localDate)
        End: \(self.end.localDate)
        """
    }
}
