//
//  EventProviding.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

protocol EventProviding {
    func getDistinctEventDates() -> [Date]
    func getEvents(on date: Date) -> [Event]
}
