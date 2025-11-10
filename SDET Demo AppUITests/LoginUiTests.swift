//
//  Untitled.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 8.11.25.
//

import XCTest

final class LoginUiTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @MainActor
    func testSuccessfulLogin() {
        // Open login form
        app.buttons["More-tab-item"].tap()
        app.otherElements["Login Button"].tap()
                
        // type username
        let usernameTextField = app.textFields.element(boundBy: 0)
        usernameTextField.tap()
        usernameTextField.typeText("bob@example.com")
        
        // type password
        let passwordTextField = app.secureTextFields.element(boundBy: 0)
        passwordTextField.tap()
        passwordTextField.typeText("10203040")
        
        // Скрываем клавиатуру, чтобы кнопка "Login" стала доступна
        app.keyboards.buttons["Return"].tap()
        
        // tap "Login" button
        app.buttons["Login"].tap()
        
        // wait for open Products screen
        let productsHeader = app.staticTexts["Products"]
        XCTAssertTrue(productsHeader.waitForExistence(timeout: 5), "Не удалось перейти на экран продуктов после логина")
    }
}
