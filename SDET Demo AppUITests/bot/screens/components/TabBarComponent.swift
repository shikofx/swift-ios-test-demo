import XCTest

class TabBarComponent: UIComponent {

    private lazy var cartItem = app.button(.tabBarItemCart)
    private lazy var menuItem = app.button(.tabBarItemMenu)
    
    @discardableResult
    func openCart() -> CartScreen {
        return step("Open cart from TabBar") {
            print(app.debugDescription)
            cartItem.tap()
            return CartScreen(app)
        }
    }
    
    @discardableResult
    func openMenu() -> MenuScreen {
        return step("Open menu from TabBar") {
            menuItem.tap()
            return MenuScreen(app)
        }
    }
}
