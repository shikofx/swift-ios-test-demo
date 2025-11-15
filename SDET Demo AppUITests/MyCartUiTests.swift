import XCTest

@MainActor
final class MyCartUiTests: BaseUiTest {
    
    override func setUp() {
        super.setUp()
        epic("UI")
        feature("Cart")
    }
    
    func testEmptyCartView() {
        story("Viewing an empty cart")
        id("TC-UI-CART-01")
        
        let cartScreen = uiBot.tabBar.openCart()
        XCTAssertExists(cartScreen.proceedToCheckoutButton, "'Proceed to Checkout' button not found")
    }
}
