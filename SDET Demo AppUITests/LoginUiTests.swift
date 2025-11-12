//
//  Untitled.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 8.11.25.
//

import XCTest

final class LoginUiTests: XCTestCase {
    
    private var app: XCUIApplication!

    
    override func setUp() {
        continueAfterFailure = false
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @MainActor
    func testLoginWithValidData() {
        let productsScreen = uiBot.menu.openLoginScreen()
            .login(username: "bob@example.com", password: "10203040")
        
        XCTAssertExists(productsScreen.productsHeader, "The Products header is not visible")
    }
}
