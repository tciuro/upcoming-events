//
//  EventConflictUIHandling.swift
//  UpcomingEvents
//
//  Created by Tito Ciuro on 2/1/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

protocol EventConflictUIHandling: class {
    
    func setConflicts(_ conflicts: [Event])

}
