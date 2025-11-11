//
//  HomeScreen.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 11.11.25.
//
import XCTest

class ProductsScreen: BaseScreen {

    lazy var productsHeader = app.staticTexts[Selector.productsHeaderText.rawValue]
    
    func isProductsHeaderVisible() -> Bool {
        return productsHeader.waitForExistence(timeout: SCREEN_TIMEOUT)
    }
    
    func verifyProductsHeaderVisible() {
        XCTAssertTrue(isProductsHeaderVisible(), "The screen is not loaded in \(SCREEN_TIMEOUT) seconds")
    }
}

extension UiBot {
    var productsScreen: ProductsScreen {
        return .init(app)
    }
}
