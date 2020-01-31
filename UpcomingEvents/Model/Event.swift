//
//  Event.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

struct Event: Codable, Hashable {
    let title: String
    let start: Date
    let end: Date
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
