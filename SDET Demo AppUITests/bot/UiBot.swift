import XCTest

class UiBot {
    internal let app: XCUIApplication
    
    lazy var tabBar = TabBarComponent(app)
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func start() {
        app.launch()
    }
}

extension XCTestCase {
    var uiBot: UiBot {
        .init(app: XCUIApplication())
    }
}
