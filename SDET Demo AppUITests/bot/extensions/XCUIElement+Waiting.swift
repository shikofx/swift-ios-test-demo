import XCTest

extension XCUIElement {

    /// Waits for the element to be visible (exists and not hidden) within the specified timeout.
    /// Note: In XCUITest, `isHittable` often implies visibility and readiness for interaction.
    /// - Parameter timeout: The maximum time to wait for the element.
    /// - Returns: True if the element becomes visible within the timeout, false otherwise.
    @discardableResult
    func waitUntilVisible(timeout: TimeInterval) -> Bool {
        var result = false
        step("Wait until element is visible: \(self.description)") {
            let hittablePredicate = NSPredicate(format: "isHittable == true")
            let expectation = XCTNSPredicateExpectation(predicate: hittablePredicate, object: self)
            result = XCTWaiter.wait(for: [expectation], timeout: timeout) == .completed
        }
        return result
    }
    
    /// Waits for the element to become not visible (i.e., to not exist) within the specified timeout.
    /// - Parameter timeout: The maximum time to wait for the element to disappear.
    /// - Returns: True if the element disappears within the timeout, false otherwise.
    @discardableResult
    func waitUntilNotVisible(timeout: TimeInterval) -> Bool { 
        step("Wait until element is not visible: \(self.description)") {
            let notExistsPredicate = NSPredicate(format: "exists == false")
            let expectation = XCTNSPredicateExpectation(predicate: notExistsPredicate, object: self)
            return XCTWaiter.wait(for: [expectation], timeout: timeout) == .completed
        }
    }
}