import XCTest

final class SortProductsScreen: BaseScreen {

    internal lazy var view: XCUIElement = app.otherElement(.sortPopupView)
    private lazy var sortByNameDescendingButton: XCUIElement = app.button(.sortByNameDescendingButton)
    private lazy var sortByNameAscendingButton: XCUIElement = app.button(.sortByNameAscendingButton)
    private lazy var sortByPriceDescendingButton: XCUIElement = app.button(.sortByPriceDescendingButton)
    private lazy var sortByPriceAscendingButton: XCUIElement = app.button(.sortByPriceAscendingButton)
    
    func waitUntilVisible() -> Self {
        view.waitUntilVisible(timeout: screenTimeout)
        return self
    }
    
    func sortByNameDescending() -> ProductsScreen {
        sortByNameDescendingButton.tap()
        return ProductsScreen(app)
    }
    
    func sortByNameAscending() -> ProductsScreen {
        sortByNameAscendingButton.tap()
        return ProductsScreen(app)
    }
    
    func sortByPriceDescending() -> ProductsScreen  {
        sortByPriceDescendingButton.tap()
        return ProductsScreen(app)
    }
    
    func sortByPriceAscending() -> ProductsScreen  {
        sortByPriceAscendingButton.tap()
        return ProductsScreen(app)
    }
}

extension UiBot {
    var sortProductsScreen: SortProductsScreen {
        return .init(app)
    }
}
