import XCTest

final class LoginUiTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        uiBot.start()
    }
    
    @MainActor
    func testLoginWithValidData() {
        let productsScreen = uiBot.tabBar.openMenu()
            .openLoginScreen()
            .login(username: "bob@example.com", password: "10203040")
        
        XCTAssertExists(productsScreen.productsHeader, "The Products header is not visible")
    }
}
