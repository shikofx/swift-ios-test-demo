import XCTest

@MainActor
class BaseUiTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Continue running tests even if one fails
        continueAfterFailure = false
        uiBot.start()
    }

    override func tearDown() {
        // Take a screenshot if the test has failed
        if testRun?.hasSucceeded == false {
            let screenshot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenshot)
            attachment.name = "Failure Screenshot"
            attachment.lifetime = .keepAlways // Keep the attachment for the report
            add(attachment)
        }
        super.tearDown()
    }
}
