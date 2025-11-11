//
//  BaseScreen.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 11.11.25.
//

import XCTest

internal class BaseScreen {
    
    internal let SCREEN_TIMEOUT: TimeInterval = 5
    
    let app: XCUIApplication!
    
    lazy var keyboard = Keyboard(app)
    
    init(_ app: XCUIApplication) {
        self.app = app
    }
}
