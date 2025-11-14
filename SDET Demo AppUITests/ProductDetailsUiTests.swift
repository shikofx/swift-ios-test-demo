import XCTest

@MainActor
final class ProductDetailsUiTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        uiBot.start()
        
        epic("UI")
        feature("Product Details")
    }
    
    func testAddProductToCart() {
        story("Adding a product to the cart")
        id("TC-UI-PD-02")
        severity("critical")
        
        let productDetails = uiBot.productsScreen.openProductDetails(at: 0)
        productDetails.addToCart()
        
        XCTAssertEqual(productDetails.cartCountLabel.label, "1", "Cart count should be updated to 1")
    }
    
    func testOpenProductDetails() {
        story("Viewing product details")
        id("TC-UI-CATALOG-04")
        let productDetails = uiBot.productsScreen.openProductDetails(at: 0)
        XCTAssertExists(productDetails.addToCartButton, "The 'Add to cart' button was not found on the product details screen.")
    }
}