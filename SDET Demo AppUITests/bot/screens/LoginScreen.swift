//
//  LoginScreen.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 11.11.25.
//
import XCTest

class LoginScreen: BaseScreen {
    
    private lazy var usernameTextField = app.textFields.element(boundBy: 0)
    private lazy var passwordTextField = app.secureTextFields.element(boundBy: 0)
    private lazy var loginButton = app.button(.loginButton)
    
    fileprivate func setUsername(_ username: String) {
        usernameTextField.tap()
        usernameTextField.typeText(username)
    }
    
    fileprivate func setPassword(_ password: String) {
        passwordTextField.tap()
        passwordTextField.typeText(password)
    }
    
    fileprivate func tapLoginButtonIfVisibleOrFail() {
        loginButton.isEnabled ? loginButton.tap() : XCTFail("Login button not found")
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
