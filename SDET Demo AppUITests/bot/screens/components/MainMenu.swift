//
//  Menu.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 11.11.25.
//

import XCTest

class MainMenu {
    private let app: XCUIApplication!

    private lazy var tabItemMore: XCUIElement = app.button(.tabItem_More)
    private lazy var itemLogin: XCUIElement = app.otherElement(.menuItem_Login)
    
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
