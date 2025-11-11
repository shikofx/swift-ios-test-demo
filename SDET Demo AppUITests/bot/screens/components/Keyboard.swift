//
//  Keyboard.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 11.11.25.
//

import XCTest

class Keyboard {
    private let app: XCUIApplication!
    
    init(_ app: XCUIApplication) {
        self.app = app
    }
    
    func tapReturn() {
        app.keyboards.buttons["Return"].tap()
    }
}
