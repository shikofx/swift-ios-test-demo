import XCTest

class ProductsScreen: BaseScreen {

    internal lazy var productsHeader = app.staticText(.productsHeaderText)
    private lazy var sortButton = app.button(.sortButton)
    
    func sort() -> SortProductsScreen{
        return step("Tap sort button") {
            sortButton.tap()
            return SortProductsScreen(app)
        }
    }
    
    @discardableResult
    func openProductDetails(at index: Int) -> ProductDetailsScreen {
        return step("Open product details at index \(index)") {
            // Open product by its index in the collection
            app.collectionViews.cells.element(boundBy: index).tap()
            return ProductDetailsScreen(app)
        }
    }
}

extension UiBot {
    var productsScreen: ProductsScreen {
        return .init(app)
    }
}
