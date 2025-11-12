import XCTest

class MainMenu : UIComponent {

    private lazy var tabItemMore: XCUIElement = app.button(.tabBarItemMenu)
    private lazy var itemLogin: XCUIElement = app.otherElement(.menuItemLogin)
    
    @discardableResult func open() -> Self {
        tabItemMore.tap()
        return self
    }
    
    @discardableResult func openLoginScreen() -> LoginScreen {
        open()
        itemLogin.tap()
        return LoginScreen(app)
    }
}

extension UiBot {
    var menu: MainMenu {
        return .init(app)
    }
}
