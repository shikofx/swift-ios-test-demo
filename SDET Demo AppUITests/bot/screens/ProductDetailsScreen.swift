import XCTest

class ProductDetailsScreen: BaseScreen {
    
    lazy var addToCartButton = app.button(.addToCartButton)
    lazy var cartCountLabel = app.staticText(.cartCountLabel)
    
    @discardableResult
    func addToCart() -> Self {
        step("Tap 'Add to cart' button") {
            addToCartButton.tap()
        }
        return self
    }
}

extension UiBot {
    var productDetailsScreen: ProductDetailsScreen { .init(app) }
}