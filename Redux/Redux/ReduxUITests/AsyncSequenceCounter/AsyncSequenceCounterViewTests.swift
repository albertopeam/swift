//
//  ReduxUITests.swift
//  ReduxUITests
//
//  Created by Alberto Penas Amor on 10/7/22.
//

import XCTest

final class ReduxUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testWhenTapPlusButtonThenOneIsAdded() throws {
        app.buttons["add"].tap()
        let count = app.staticTexts["count"]

        XCTAssertLabel(for: count, isEqualTo: "1")
    }
}
