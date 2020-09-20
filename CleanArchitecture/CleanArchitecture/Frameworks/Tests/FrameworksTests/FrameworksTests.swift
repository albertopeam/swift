import XCTest
@testable import Frameworks

final class FrameworksTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Frameworks().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
