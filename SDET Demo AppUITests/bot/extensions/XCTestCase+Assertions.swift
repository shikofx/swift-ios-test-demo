//
//  XCTestCase+Assertions.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 12.11.25.
//

import XCTest

extension XCTestCase {

    /// Asserts that a UI element exists within a specified timeout.
    ///
    /// This function behaves like a standard XCTest assertion, reporting failures
    /// at the call site.
    ///
    /// - Parameters:
    ///   - element: The `XCUIElement` to check for existence.
    ///   - timeout: The maximum time to wait for the element to exist. Defaults to 5 seconds.
    ///   - message: An optional description to display if the assertion fails.
    ///   - file: The file where the failure occurs. The default is the filename of the test case.
    ///   - line: The line number where the failure occurs. The default is the line number of the assertion.
    func XCTAssertExists(_ element: XCUIElement, timeout: TimeInterval = 5.0, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
        let doesExist = element.waitForExistence(timeout: timeout)
        
        if !doesExist {
            let customMessage = message.isEmpty ? "Element \(element.description) does not exist after \(timeout) seconds." : message
            XCTFail(customMessage, file: file, line: line)
        }
    }
    
    /// Asserts that a UI element is visible (exists, is visible, and enabled) within a specified timeout.
    func XCTAssertVisible(_ element: XCUIElement, timeout: TimeInterval = 5.0, _ message: String = "", file: StaticString = #filePath, line: UInt = #line) {
        if !element.waitUntilVisible(timeout: timeout) {
            let customMessage = message.isEmpty ? "Element \(element.description) is not visible after \(timeout) seconds." : message
            XCTFail(customMessage, file: file, line: line)
        }
    }
}