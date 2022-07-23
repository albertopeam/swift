//
//  ReduxUITests.swift
//  ReduxUITests
//
//  Created by Alberto Penas Amor on 10/7/22.
//

import XCTest

final class AsyncSequenceCounterViewUITests: XCTestCase {
    private let app = XCUIApplication()
    private lazy var countLabel = app.staticTexts["count"]
    private lazy var addButton = app.buttons["add"]
    private lazy var subtractButton = app.buttons["subtract"]
    private lazy var resetButton = app.buttons["reset"]

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testWhenTapPlusButtonThenCountIsOne() throws {
        addButton.tap()

        assertButtonsAreDisabled()
        XCTAssertLabel(for: countLabel, isEqualTo: "1")
    }

    func testWhenTapSubtractButtonThenCountIsMinusOne() throws {
        subtractButton.tap()

        assertButtonsAreDisabled()
        XCTAssertLabel(for: countLabel, isEqualTo: "-1")
    }

    func testWhenTapResetButtonThenCountIsZero() throws {
        addButton.tap()
        XCTAssertLabel(for: countLabel, isEqualTo: "1")

        resetButton.tap()
        XCTAssertLabel(for: countLabel, isEqualTo: "0")
    }

    // MARK: - private

    private func assertButtonsAreDisabled() {
        XCTAssertFalse(addButton.isEnabled)
        XCTAssertFalse(subtractButton.isEnabled)
        XCTAssertFalse(resetButton.isEnabled)
    }
}
