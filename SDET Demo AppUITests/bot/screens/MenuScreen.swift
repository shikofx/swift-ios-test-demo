import XCTest

class MenuScreen: BaseScreen {

    private lazy var itemLogin: XCUIElement = app.otherElement(.menuItemLogin)

    @discardableResult func openLoginScreen() -> LoginScreen {
        itemLogin.tap()
        return LoginScreen(app)
    }
}

extension UiBot {
    var menuScreen: MenuScreen { .init(app) }
}
