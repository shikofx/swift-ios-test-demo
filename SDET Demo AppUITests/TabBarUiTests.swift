import XCTest

final class TabBarUiTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        uiBot.start()
    }
    
    @MainActor
    func testOpenCart() {
        let cartScreen = uiBot.tabBar.openCart()
        
        XCTAssertExists(cartScreen.proceedToCheckoutButton, "The 'Proceed to Checkout' button was not found on the cart screen.")
    }
}