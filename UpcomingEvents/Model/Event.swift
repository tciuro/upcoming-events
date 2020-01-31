//
//  Event.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

struct Event: Codable {
    let title: String
    let start: Date
    let end: Date
}
