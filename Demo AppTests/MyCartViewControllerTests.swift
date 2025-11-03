//
//  MyCartViewControllerTests.swift
//  MyCartViewControllerTests
//
//  Created by d parkheychuk on 16.10.25.
//

import XCTest

@testable import SDET_Demo_App

final class MyCartViewControllerTest: XCTestCase {
    
    var controller: MyCartViewController!
    var engine: Engine!
    
    override func setUp() {
        engine = Engine()
        Engine.sharedInstance = engine
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        controller = storyboard.instantiateViewController(identifier: "MyCartViewController") as? MyCartViewController
        controller.loadViewIfNeeded()
        
        super.setUp()
    }
    
    override func tearDown() {
        controller = nil
        engine = nil
        super.tearDown()
    }
    
    
    
    func testCalculateTotalPriceForEmptyCart() {
        given("empty card list")  { _ in
            engine.cartList = []
        }
        
        when("calculate total price") { _ in
            controller.calculateTotalPrice()
        }
        
        then("total price should be zero") { _ in
            XCTAssertEqual(engine.totalPrice, 0.00)
            XCTAssertEqual(controller.totalPriceLbl.text, "$0.00")
        }
    
    }
    
    func testCalculateTotalPriceWhenCartHasOneItem() {
        given("cart with one item")  { _ in
            engine.cartList = [
                ["ProductPrice": "15.99", "ProductQuantity": 2]
            ]
        }
        
        when("calculate total price") { _ in
            controller.calculateTotalPrice()
        }
        
        then("result is equal ProductPrice * ProductQuantity = 15.99 * 2 = 31.98") { _ in
            XCTAssertEqual(engine.totalPrice, 31.98, accuracy: 0.01)
        }
    }
    
    func testCalculateTotalPriceWhenCartHasMultipleItems() {
        given("cart with multiple items")  { _ in
            engine.cartList = [
                ["ProductPrice": "15.99", "ProductQuantity": 2],
                ["ProductPrice": "24.95", "ProductQuantity": 1],
                ["ProductPrice": "10.00", "ProductQuantity": 3]
            ]
        }
        
        when("calculate total price") { _ in
            controller.calculateTotalPrice()
        }
        
        then("total price should be calculated for all of items in the list") { _ in
            XCTAssertEqual(engine.totalPrice, 86.93, accuracy: 0.01)
        }
    }
    
    func testAddButtonIncresesQuantityAndCartCount() {
        given("cart with one item")  { _ in
            engine.cartCount = 1
            engine.cartList = [
                ["ProductPrice": "15.99", "ProductQuantity": 2]
            ]
        }

        when("press button '+") { _ in
            let addButton = UIButton()
            addButton.tag = 0
            controller.addButton(addButton)
        }

        then( "product items count and cardCount should be increased", _block: { _ in
            XCTAssertEqual(engine.cartList[0]["ProductQuantity"] as! Int, 3)
            XCTAssertEqual(engine.cartCount, 2)
        })
    }

    func testSubtractButtonRemovesProductWhenQuantityIsOne() {
        given("cart with one item") { _ in
            let item: NSMutableDictionary = ["ProductPrice": "10.00", "ProductQuantity": 1]
            engine.cartList = [item]
            engine.cartCount = 1
        }

        when("press button '-'") { _ in
            let mockButton = UIButton()
            mockButton.tag = 0
            controller.subtractButton(mockButton)
        }

        then("cart list should be empty and cart count should be 0") { _ in
            XCTAssertTrue(engine.cartList.isEmpty)
            XCTAssertEqual(engine.cartCount, 0)
        }
    }

    func testSubtractButtonDecreasesQuantityAndCartCount() {
        given("product quantity is 3 and cart count is 3") { _ in
            let item: NSMutableDictionary = ["ProductPrice": "10.00", "ProductQuantity": 3]
            engine.cartList = [item]
            engine.cartCount = 3
        }

        when("priess button '-'") { _ in
            let mockButton = UIButton()
            mockButton.tag = 0
            controller.subtractButton(mockButton)
        }

        then("product is in list with quantity 2 and cart count is 2") { _ in
            XCTAssertEqual(engine.cartList[0]["ProductQuantity"] as? Int, 2)
            XCTAssertEqual(engine.cartCount, 2)
            XCTAssertEqual(engine.cartList.count, 1, "Product list should contain only one item")
        }
    }

    func testDeleteProductRemovesProductFromCart() {
        given("cart with one item") { _ in
            let item: NSMutableDictionary = ["ProductPrice": "10.00", "ProductQuantity": 3]
            engine.cartList = [item]
            engine.cartCount = 3
        }

        when("priess button 'delete'") { _ in
            let mockButton = UIButton()
            mockButton.tag = 0
            controller.deleteProduct(mockButton)
        }

        then("cart list should be empty and cart count should be 0") { _ in
            XCTAssertTrue(engine.cartList.isEmpty)
            XCTAssertEqual(engine.cartCount, 0)
        }
    }
}
