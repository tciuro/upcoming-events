import XCTest
@testable import UpcomingEvents

final class UpcomingEventsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(UpcomingEvents().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
