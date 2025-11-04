//
//  MyCartViewControllerTests.swift
//  MyCartViewControllerTests
//
//  Created by d parkheychuk on 17.10.25.
//

import XCTest

@testable import SDET_Demo_App

final class CatalogViewControllerTests: XCTestCase {

    var engine: Engine!
    var controller: CatalogViewController!
    let unsortedList: [NSMutableDictionary] = [
        ["ProductName": "Sauce Labs T-Shirt", "ProductPrice": "15.99"],
        ["ProductName": "Sauce Labs Backpack", "ProductPrice": "29.99"],
        ["ProductName": "Sauce Labs Onesie", "ProductPrice": "7.99"]
    ]
    
    override func setUp() {
        engine = Engine()
        Engine.sharedInstance = engine
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        controller = storyboard.instantiateViewController(identifier: "CatalogViewController") as? CatalogViewController
        controller.loadViewIfNeeded() 
    }
    
    override func tearDown() {
        engine = nil
        controller = nil
    }
    
    func testSortByNameAscending() {
        given("unsorted list: \(unsortedList)") { _ in
            engine.productList = unsortedList
        }
        
        when("sort by name ascending") { _ in
            controller.nameAscendingButton(controller.nameAscendingBtn)
        }
        
        then("list is sorted by name") { _ in
            let expectedList: [NSMutableDictionary] = [
                ["ProductName": "Sauce Labs Backpack", "ProductPrice": "29.99"],
                ["ProductName": "Sauce Labs Onesie", "ProductPrice": "7.99"],
                ["ProductName": "Sauce Labs T-Shirt", "ProductPrice": "15.99"]
            ]
            
            XCTAssertEqual(engine.productList, expectedList)
        }
    }
    
    func testSortByNameDescending() {
        given("unsorted list: \(unsortedList)") { _ in
            engine.productList = unsortedList
        }
        
        when("sort by name descending") { _ in
            controller.nameDescendingButton(controller.nameDescendingBtn)
        }
        
        then("list is sorted by name descending") { _ in
            let expectedList: [NSMutableDictionary] = [
                ["ProductName": "Sauce Labs T-Shirt", "ProductPrice": "15.99"],
                ["ProductName": "Sauce Labs Onesie", "ProductPrice": "7.99"],
                ["ProductName": "Sauce Labs Backpack", "ProductPrice": "29.99"]
            ]
            
            XCTAssertEqual(engine.productList, expectedList)
        }
    }
    
    func testSortByPriceAscending() {
        given("unsorted list: \(unsortedList)") { _ in
            engine.productList = unsortedList
        }
        
        when("sort by name ascending") { _ in
            controller.priceAscendingButton(controller.priceAscendingBtn)
        }
        
        then("list is sorted by price ascending") { _ in
            let expectedList: [NSMutableDictionary] = [
                ["ProductName": "Sauce Labs Onesie", "ProductPrice": "7.99"],
                ["ProductName": "Sauce Labs T-Shirt", "ProductPrice": "15.99"],
                ["ProductName": "Sauce Labs Backpack", "ProductPrice": "29.99"]
            ]
            
            XCTAssertEqual(engine.productList, expectedList)
        }
    }
    
    func testSortByPriceDescending() {
        given("unsorted list: \(unsortedList)") { _ in
            engine.productList = unsortedList
        }
        
        when("sort by price descending") { _ in
            controller.priceDescendingButton(controller.priceDescendingBtn)
        }
        
        then("list is sorted by price descending") { _ in
            let expectedList: [NSMutableDictionary] = [
                ["ProductName": "Sauce Labs Backpack", "ProductPrice": "29.99"],
                ["ProductName": "Sauce Labs T-Shirt", "ProductPrice": "15.99"],
                ["ProductName": "Sauce Labs Onesie", "ProductPrice": "7.99"]
            ]
            
            XCTAssertEqual(engine.productList, expectedList)
        }
    }
}
