//
//  Demo_AppTests.swift
//  Demo AppTests
//
//  Created by d parkheychuk on 16.10.25.
//

import XCTest

class Demo_AppTests: XCTestCase {

    func testSum() {
        let expected = 15
        
        let sum = 12 + 3
        
        XCTAssertEqual(expected, sum, "Sum is incorrect")
    }

}
