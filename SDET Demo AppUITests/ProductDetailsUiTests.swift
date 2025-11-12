import XCTest

final class ProductDetailsUiTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        uiBot.start()
    }
    
    @MainActor
    func testAddProductToCart() {
        let productDetails = uiBot.productsScreen.openProductDetails(at: 0)
        
        productDetails.addToCart()
        
        XCTAssertEqual(productDetails.cartCountLabel.label, "1", "Cart count should be updated to 1")
    }
    
    @MainActor
    func testOpenProductDetails() {
        let productDetails = uiBot.productsScreen.openProductDetails(at: 0)
        
        XCTAssertExists(productDetails.addToCartButton, "The 'Add to cart' button was not found on the product details screen.")
    }
}