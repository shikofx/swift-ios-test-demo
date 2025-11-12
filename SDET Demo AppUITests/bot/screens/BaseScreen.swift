import XCTest

internal class BaseScreen {
    
    internal var screenTimeout: TimeInterval = 5.0 // Renamed to be more Swift-idiomatic and made mutable
    
    let app: XCUIApplication!
    
    lazy var keyboard = Keyboard(app)
    
    init(_ app: XCUIApplication) {
        self.app = app
    }
    
}
