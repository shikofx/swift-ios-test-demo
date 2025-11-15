import XCTest

@MainActor
final class LoginUiTests: BaseUiTest {
    override func setUp() {
        super.setUp()
        epic("UI")
        feature("Authentication")
    }
    
    func testLoginWithValidData() throws {
        story("Successful login")
        severity("blocker")
        
        throw XCTSkip("Test disabled: No way to close the keyboard after entering the password. [Bug: #YOUR_BUG_TRACKER_ID]")

        let productsScreen = uiBot.tabBar.openMenu()
            .openLoginScreen()
            .login(username: "bob@example.com", password: "10203040")
        XCTAssertExists(productsScreen.productsHeader, "The Products header is not visible")
    }
}
