//
//  UpcomingEventsTests.swift
//  UpcomingEventsTests
//
//  Created by Tito Ciuro on 1/30/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import XCTest
@testable import UpcomingEvents

class UpcomingEventsTests: XCTestCase {

    private var mockFileURL: URL!
    private var dateFormatter: DateFormatter!

    override func setUp() {
        mockFileURL = Bundle.main.url(forResource: "mock", withExtension: "json")!
        
        dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
    }

    func test_load_all_events() {
        let expectation = XCTestExpectation(description: "Loading all events")
        
        let fileEventDataService = FileEventDataService(at: mockFileURL)
        fileEventDataService.loadEvents {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        //let eventDataService = EventDataService(eventDataService: fileEventDataService)
    }
    
    func test_check_distinct_dates_count() {
        let expectation = XCTestExpectation(description: "Check the distinct dates count")
        
        let fileEventDataService = FileEventDataService(at: mockFileURL)
        fileEventDataService.loadEvents {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        let distinctDates = fileEventDataService.getDistinctEventDates()
        let groupedEvents = fileEventDataService.getEventsGroupedByDay()
        XCTAssertEqual(distinctDates.count, groupedEvents.count)
    }
    
    func test_distinct_dates_are_sorted() {
        let expectation = XCTestExpectation(description: "Check that the distinct dates are sorted")
        
        let fileEventDataService = FileEventDataService(at: mockFileURL)
        fileEventDataService.loadEvents {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        let distinctDates = fileEventDataService.getDistinctEventDates()
        let distinctDatesSorted = fileEventDataService.getDistinctEventDates().sorted(by: <)
        XCTAssertEqual(distinctDates, distinctDatesSorted)
    }
    
    func test_number_of_events_per_day() {
        let expectation = XCTestExpectation(description: "Check number of events per day")
        
        let fileEventDataService = FileEventDataService(at: mockFileURL)
        fileEventDataService.loadEvents {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        let distinctDates = fileEventDataService.getDistinctEventDates()
        var eventsCountList = [Int]()
        
        for distinctDate in distinctDates {
            let eventCount = fileEventDataService.getEvents(on: distinctDate).count
            eventsCountList.append(eventCount)
        }
        
        XCTAssertEqual(eventsCountList, [3, 2, 4, 2, 3, 4, 3])
    }
    
    func test_number_of_event_conflicts_per_day() {
        let expectation = XCTestExpectation(description: "Check number of event conflicts per day")
        
        let fileEventDataService = FileEventDataService(at: mockFileURL)
        fileEventDataService.loadEvents {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        let days = fileEventDataService.getEventsGroupedByDay()
        var eventsCountList = [Int]()
        
        for day in days {
            let conflictCount = day.eventConflicts.count
            eventsCountList.append(conflictCount)
        }
        
        XCTAssertEqual(eventsCountList, [0, 2, 2, 0, 2, 2, 3])
    }
    
    func test_day_without_conflicts() {
        let ev1 = Event(title: "Day 1",
                        start: _date(year: 2020, month: 5, day: 23, hour: 8, minute: 30, second: 0)!,
                        end: _date(year: 2020, month: 5, day: 23, hour: 12, minute: 0, second: 0)!)
        let ev2 = Event(title: "Day 1",
                        start: _date(year: 2020, month: 5, day: 23, hour: 12, minute: 0, second: 0)!,
                        end: _date(year: 2020, month: 5, day: 23, hour: 18, minute: 0, second: 0)!)
        let day = Day(date: _date(year: 2020, month: 5, day: 23)!, events: [ev1, ev2])

        XCTAssertEqual(day.eventConflicts.count, 0)
    }
    
    func test_day_with_conflicts() {
        let ev1 = Event(title: "Day 1",
                        start: _date(year: 2020, month: 5, day: 23, hour: 15, minute: 0, second: 0)!,
                        end: _date(year: 2020, month: 5, day: 23, hour: 18, minute: 30, second: 0)!)
        let ev2 = Event(title: "Day 1",
                        start: _date(year: 2020, month: 5, day: 23, hour: 12, minute: 0, second: 0)!,
                        end: _date(year: 2020, month: 5, day: 23, hour: 18, minute: 0, second: 0)!)
        let ev3 = Event(title: "Day 1",
                        start: _date(year: 2020, month: 5, day: 23, hour: 8, minute: 0, second: 0)!,
                        end: _date(year: 2020, month: 5, day: 23, hour: 13, minute: 0, second: 0)!)
        let day = Day(date: _date(year: 2020, month: 5, day: 23)!, events: [ev1, ev2, ev3])
        
        XCTAssertEqual(day.eventConflicts.count, 3)
    }
    
    // MARK: - Private Section -
    
    func _date(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date? {
        let dateComponents = DateComponents(calendar: dateFormatter.calendar, timeZone: dateFormatter.timeZone, year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        return dateFormatter.calendar.date(from: dateComponents)
    }

}
