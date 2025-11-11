//
//  UiBot.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 11.11.25.
//

import XCTest

class UiBot {
    internal let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
        app.launch()
    }
}

extension XCTestCase {
    var uiBot: UiBot {
        .init(app: XCUIApplication())
    }
}
