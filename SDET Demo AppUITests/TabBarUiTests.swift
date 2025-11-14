import XCTest

@MainActor
final class TabBarUiTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        uiBot.start()
        
        epic("UI")
        feature("Navigation")
    }
    
    func testOpenCart() {
        story("Navigating to cart via TabBar")
        id("TC-UI-CATALOG-05")
        let cartScreen = uiBot.tabBar.openCart()
        XCTAssertExists(cartScreen.proceedToCheckoutButton, "The 'Proceed to Checkout' button was not found on the cart screen.")
    }
}