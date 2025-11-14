import XCTest

class LoginScreen: BaseScreen {
    
    private lazy var usernameTextField = app.textFields.element(boundBy: 0)
    private lazy var passwordTextField = app.secureTextFields.element(boundBy: 0)
    private lazy var loginButton = app.button(.loginButton)
    
    fileprivate func setUsername(_ username: String) {
        step("Enter username: \(username)") {
            usernameTextField.tap()
            usernameTextField.typeText(username)
        }
    }
    
    fileprivate func setPassword(_ password: String) {
        step("Enter password") {
            passwordTextField.tap()
            passwordTextField.typeText(password)
        }
    }
    
    fileprivate func tapLoginButtonIfVisibleOrFail() {
        step("Tap login button") {
            loginButton.isEnabled ? loginButton.tap() : XCTFail("Login button not found")
        }
    }
    
    @discardableResult
    func login(username: String, password: String) -> ProductsScreen {
        setUsername(username)
        setPassword(password)
        tapLoginButtonIfVisibleOrFail()
        
        return ProductsScreen(app)
    }
}

extension UiBot {
    var loginScreen: LoginScreen {
        return .init(app)
    }
}
