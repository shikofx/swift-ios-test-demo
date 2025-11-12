import XCTest

class ProductsScreen: BaseScreen {

    internal lazy var productsHeader = app.staticText(.productsHeaderText)
    private lazy var sortButton = app.button(.sortButton)
    
    func sort() -> SortProductsScreen{
        sortButton.tap()
        return SortProductsScreen(app)
    }
    
    @available(*, deprecated, message: "Use openProductDetails(at:) instead. Relying on names is brittle.")
    @discardableResult
    func openProductDetails(named name: String) -> ProductDetailsScreen {
        app.collectionViews.cells["productCell_\(name)"].firstMatch.tap()
        return ProductDetailsScreen(app)
    }
    
    @discardableResult
    func openProductDetails(at index: Int) -> ProductDetailsScreen {
        // Открываем товар по его индексу в коллекции
        app.collectionViews.cells.element(boundBy: index).tap()
        return ProductDetailsScreen(app)
    }
}

extension UiBot {
    var productsScreen: ProductsScreen {
        return .init(app)
    }
}
