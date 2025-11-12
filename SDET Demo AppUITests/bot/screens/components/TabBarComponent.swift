import XCTest

class TabBarComponent: UIComponent {

    private lazy var cartItem = app.button(.tabBarItemCart)
    private lazy var menuItem = app.button(.tabBarItemMenu)
    
    @discardableResult
    func openCart() -> CartScreen {
        print(app.debugDescription)
        cartItem.tap()
        return CartScreen(app)
    }
    
    @discardableResult
    func openMenu() -> MenuScreen {
        menuItem.tap()
        return MenuScreen(app)
    }
}
