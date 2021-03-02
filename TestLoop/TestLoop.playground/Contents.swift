import Foundation
import XCTest

class DemoTests: XCTestCase {
    private var mock: Mock = .init()

    override func setUp() {
        super.setUp()
        print(Unmanaged.passUnretained(mock).toOpaque())
        print(Unmanaged.passUnretained(self).toOpaque())
    }

    func test1() {
        mock.times += 1
        XCTAssertEqual(1, mock.times)
    }

    func test2() {
        mock.times += 1
        XCTAssertEqual(1, mock.times)
    }

}

class Mock {
    var times: Int = 0
}

DemoTests.defaultTestSuite.run()
