//
//  HomeScreen.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 11.11.25.
//
import XCTest

class ProductsScreen: BaseScreen {

    lazy var productsHeader = app.staticText(.productsHeaderText)
    
    func isProductsHeaderVisible() -> Bool {
        return productsHeader.waitForExistence(timeout: screenTimeout) // Используем унаследованный screenTimeout
    }
}

extension UiBot {
    var productsScreen: ProductsScreen {
        return .init(app)
    }
}
