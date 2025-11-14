//
//  LoginViewControllerTest.swift
//  SDET Demo App
//
//  Created by d parkheychuk on 4.11.25.
//

import XCTest
@testable import SDET_Demo_App

final class LoginViewControllerTest: XCTestCase {
    var mock: MethodsMock!
    var controller: LoginViewController!
    
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        controller.loadViewIfNeeded()
        mock = MethodsMock()
        controller.methods = mock
        
        epic("Unit")
        feature("Authentication")
    }
    
    override func tearDown() {
        mock = nil
        controller = nil
        super.tearDown()
    }
    
    func testEmptyUsernameValidation() {
        story("Field validation")
        id("UC-LV-001")
        given("empty username and valid password") { _ in
            controller.userNameTF.text = ""
            controller.passwordTF.text = "ValidPassword"
        }
        
        when("login button is pressed") { _ in
            controller.loginButton(self)
        }
        
        then("message alert is shown") { _ in
            XCTAssertTrue(mock.showAlertCalled)
            XCTAssertEqual(mock.alertMessage, "Username is required")
        }
    }
    
    func testEmptyPasswordValidation() {
        story("Field validation")
        id("UC-LV-002")
        given("valid username and empty password") { _ in
            controller.userNameTF.text = "ValidUserName"
            controller.passwordTF.text = ""
        }
        
        when("login button is pressed") { _ in
            controller.loginButton(self)
        }
        
        then("message alert is shown") { _ in
            XCTAssertTrue(self.mock.showAlertCalled)
            XCTAssertEqual(self.mock.alertMessage, "Password is required")
        }
    }
}
