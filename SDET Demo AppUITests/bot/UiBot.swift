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

extension BaseUiTest {
    var uiBot: UiBot {
        .init(app: XCUIApplication())
    }
}
