import XCTest

final class LoginUiTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        uiBot.start()
    }
    
    @MainActor
    func testLoginWithValidData() throws {
        throw XCTSkip("Test disabled: No way to close the keyboard after entering the password. [Bug: #YOUR_BUG_TRACKER_ID]")

        let productsScreen = uiBot.tabBar.openMenu()
            .openLoginScreen()
            .login(username: "bob@example.com", password: "10203040")
        
        XCTAssertExists(productsScreen.productsHeader, "The Products header is not visible")
    }
}
