import XCTest

class CartScreen: BaseScreen {
    lazy var proceedToCheckoutButton = app.button(.proceedToCheckoutButton)
}

extension UiBot {
    var cartScreen: CartScreen { .init(app) }
}
