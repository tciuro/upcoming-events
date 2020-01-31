//
//  Day.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/31/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

struct Day {
    
    let date: Date
    let events: [Event]
    private var eventConflicts: Set<Event>!
    
    init(date: Date, events: [Event]) {
        self.date = date
        self.events = events.sorted(by: { ev1, ev2 -> Bool in
            ev1.start < ev2.start
        })
        self.eventConflicts = checkForConflicts()
    }
    
    func isEventInConflict(_ event: Event) -> Bool {
        return eventConflicts.contains(event)
    }
    
    /// Checks whether the day contains conflicting events. Time complexity is O(nlogn) + O(n) -> O(nlogn) because the list has been previously sorted.
    mutating func checkForConflicts() -> Set<Event> {
        guard events.count > 1, let firstEvent = events.first else { return [] }
        
        var conflicts = Set<Event>()
        
        var lastMaxEndTimeEvent = firstEvent
        
        for i in 1 ..< events.count {
            let event = events[i]
            
            if lastMaxEndTimeEvent.end > event.start {
                // Conflict detected!
                conflicts.insert(lastMaxEndTimeEvent)
                conflicts.insert(event)
                lastMaxEndTimeEvent = lastMaxEndTimeEvent.end > event.end ? lastMaxEndTimeEvent : event
            } else {
                // No conflict, move on...
                lastMaxEndTimeEvent = event
            }
        }
        
        return conflicts
    }
}
