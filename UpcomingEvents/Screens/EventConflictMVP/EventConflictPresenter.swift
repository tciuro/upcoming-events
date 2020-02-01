//
//  EventConflictPresenter.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 2/1/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

class EventConflictPresenter  {
    
    private weak var ui: EventConflictUIHandling?
    private var event: Event

    init(ui: EventConflictUIHandling, event: Event) {
        self.ui = ui
        self.event = event
    }
    
    func getConflicts() {
        ui?.setConflicts(event.getConflicts() ?? [])
    }
    
}
