//
//  Menu.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 11.11.25.
//

import XCTest

class MainMenu {
    private let app: XCUIApplication!

    private lazy var tabItemMore: XCUIElement = app.buttons["More-tab-item"]
    private lazy var itemLogin: XCUIElement = app.otherElements["Login Button"]
    
    init(_ app: XCUIApplication) {
        self.app = app
    }
    
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
