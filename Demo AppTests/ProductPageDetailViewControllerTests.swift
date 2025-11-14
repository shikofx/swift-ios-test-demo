//
//  ProductPageDetailViewControllerTests.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 3.11.25.
//

import XCTest

@testable import SDET_Demo_App

final class ProductPageDetailViewControllerTests : XCTestCase {
    var engine: Engine!
    var controller: ProductPageDetailViewController!
    
    override func setUp() {
        self.engine = Engine()
        Engine.sharedInstance = self.engine
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "ProductPageDetailViewController") as? ProductPageDetailViewController
        controller.productName = "Test Product"
        controller.productPrice = "100.00"
        controller.productId = "123"
        controller.productHighlights = "Highlight 1"
        
        controller.loadViewIfNeeded()
        
        epic("Unit")
        feature("Product Details")
        super.setUp()
    }
    
    override func tearDown() {
        engine = nil
        controller = nil
        super.tearDown()
    }
    
    func testAddToCartSingleItem() {
        story("Adding to cart")
        id("UC-PPDV-001")
        given("empty cart") { _ in
            engine.cartList.removeAll()
            engine.cartCount = 0
        }
        
        when("add item to cart") { _ in
            controller.addToCartButton(controller.addToCartBtn)
        }
        
        then("cart contains one item") { _ in
            XCTAssertEqual(self.engine.cartCount, 1)
            XCTAssertEqual(self.engine.cartList.count, 1)
            
            let cartItem = engine.cartList.first!
            
            XCTAssertEqual(cartItem["ProductQuantity"] as? Int, 1)
        }
    }
    
    func testAddToCartSingleItemTwice() {
        story("Adding to cart")
        id("UC-PPDV-003")
        given("empty cart") { _ in
            engine.cartList.removeAll()
            engine.cartCount = 0
        }
        
        when("add item to cart twice") { _ in
            controller.addToCartButton(controller.addToCartBtn)
            controller.addToCartButton(controller.addToCartBtn)
        }
        
        then("cart contains two items") { _ in
            XCTAssertEqual(self.engine.cartCount, 2)
            XCTAssertEqual(self.engine.cartList.count, 1)
            
            let cartItem = self.engine.cartList.first!
            
            XCTAssertEqual(cartItem["ProductQuantity"] as? Int, 2)
            
        }
    }
    
    func testAddToCartMultipleItems() {
        story("Adding to cart")
        id("UC-PPDV-004")
        given("empty cart)") { _ in
            engine.cartList.removeAll()
            engine.cartCount = 0
        }
        
        when("increase items quantity") { _ in
            controller.addButton(controller.addBtn)
            controller.addButton(controller.addBtn)
            
            controller.addToCartButton(controller.addToCartBtn)
        }
        
        then("cart contains one item with quantity 3") { _ in
            XCTAssertEqual(self.engine.cartCount, 3)
            XCTAssertEqual(self.engine.cartList.count, 1)
            
            let cartItem = self.engine.cartList.first!
            
            XCTAssertEqual(cartItem["ProductQuantity"] as? Int, 3)
        }
    }
    
    
}
