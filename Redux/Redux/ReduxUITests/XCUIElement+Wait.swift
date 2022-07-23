//
//  XCUIElement+Wait.swift
//  ReduxUITests
//
//  Created by Alberto Penas Amor on 21/7/22.
//

import Foundation
import XCTest

extension XCTest {
    func XCTAssertLabel(for element: XCUIElement, isEqualTo value: String, timeout: TimeInterval = 5) {
        let result = element.waitForLabel(equalTo: value)
        XCTAssertTrue(result)
    }

}

extension XCUIElement {
    func waitForLabel(equalTo value: String, timeout: TimeInterval = 5) -> Bool {
        let format = "label == '\(value)'"
        let predicate = NSPredicate(format: format, argumentArray: nil)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
}
