import XCTest

final class SortProductsScreen: BaseScreen {

    internal lazy var view: XCUIElement = app.otherElement(.sortPopupView)
    private lazy var sortByNameDescendingButton: XCUIElement = app.button(.sortByNameDescendingButton)
    private lazy var sortByNameAscendingButton: XCUIElement = app.button(.sortByNameAscendingButton)
    private lazy var sortByPriceDescendingButton: XCUIElement = app.button(.sortByPriceDescendingButton)
    private lazy var sortByPriceAscendingButton: XCUIElement = app.button(.sortByPriceAscendingButton)
    
    func waitUntilVisible() -> Self {
        step("Wait until sort options are visible") {
            view.waitUntilVisible(timeout: screenTimeout)
        }
        return self
    }
    
    func sortByNameDescending() -> ProductsScreen {
        return step("Sort by name descending") {
            sortByNameDescendingButton.tap()
            return ProductsScreen(app)
        }
    }
    
    func sortByNameAscending() -> ProductsScreen {
        return step("Sort by name ascending") {
            sortByNameAscendingButton.tap()
            return ProductsScreen(app)
        }
    }
    
    func sortByPriceDescending() -> ProductsScreen  {
        return step("Sort by price descending") {
            sortByPriceDescendingButton.tap()
            return ProductsScreen(app)
        }
    }
    
    func sortByPriceAscending() -> ProductsScreen  {
        return step("Sort by price ascending") {
            sortByPriceAscendingButton.tap()
            return ProductsScreen(app)
        }
    }
}
