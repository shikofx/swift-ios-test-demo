import XCTest

class Keyboard: UIComponent {
        
    func tapReturn() {
        step("Tap 'Return' on the keyboard") {
            app.keyboards.buttons["Return"].tap()
        }
    }
}

extension UiBot {
    var keyboard: Keyboard {
        return .init(app)
    }
}
