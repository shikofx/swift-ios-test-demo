import XCTest

class MainMenu : UIComponent {

    private lazy var tabItemMore: XCUIElement = app.button(.tabBarItemMenu)
    private lazy var itemLogin: XCUIElement = app.otherElement(.menuItemLogin)
    
    @discardableResult func open() -> Self {
        step("Open main menu") {
            tabItemMore.tap()
        }
        return self
    }
    
    @discardableResult func openLoginScreen() -> LoginScreen {
        return step("Open login screen from menu") {
            tabItemMore.tap()
            itemLogin.tap()
            return LoginScreen(app)
        }
    }
}

extension UiBot {
    var menu: MainMenu {
        return .init(app)
    }
}
