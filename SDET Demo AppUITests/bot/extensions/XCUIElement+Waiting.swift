//
//  XCUIElement+Waiting.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 12.11.25.
//

import XCTest

extension XCUIElement {

    /// Waits for the element to be visible (exists and not hidden) within the specified timeout.
    /// Note: In XCUITest, `isHittable` often implies visibility and readiness for interaction.
    /// - Parameter timeout: The maximum time to wait for the element.
    /// - Returns: True if the element becomes visible within the timeout, false otherwise.
    @discardableResult
    func waitUntilVisible(timeout: TimeInterval) -> Bool {
        let hittablePredicate = NSPredicate(format: "isHittable == true")
        let expectation = XCTNSPredicateExpectation(predicate: hittablePredicate, object: self)
        return XCTWaiter.wait(for: [expectation], timeout: timeout) == .completed
    }
}