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
    
    override func setUp() {
        engine = Engine()
        Engine.sharedInstance = engine
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        controller = storyboard.instantiateViewController(identifier: "CatalogViewController") as? CatalogViewController
    }
    
    override func tearDown() {
        engine = nil
        controller = nil
    }
    
    func test_sort_ByName() {
        given("unsorted list") { _ in
            
        }
        
        when("sort by name") { _ in
            
        }
        
        then("list is sorted by name") { _ in
            
        }
    }
}
