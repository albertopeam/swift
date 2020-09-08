import XCTest
@testable import Adapters

final class AdaptersTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Adapters().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
