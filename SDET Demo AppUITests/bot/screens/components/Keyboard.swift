import XCTest

class Keyboard: UIComponent {
        
    func tapReturn() {
        app.keyboards.buttons["Return"].tap()
    }
}

extension UiBot {
    var keyboard: Keyboard {
        return .init(app)
    }
}
