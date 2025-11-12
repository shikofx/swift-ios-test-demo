import XCTest

extension XCUIApplication {

    func button(_ element: Selector) -> XCUIElement {
        return self.buttons[element.rawValue]
    }

    func textField(_ element: Selector) -> XCUIElement {
        return self.textFields[element.rawValue]
    }
    
    func staticText(_ element: Selector) -> XCUIElement {
        return self.staticTexts[element.rawValue]
    }
    
    func otherElement(_ element: Selector) -> XCUIElement {
        return self.otherElements[element.rawValue]
    }
    
}
