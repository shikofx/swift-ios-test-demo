import XCTest

final class CatalogUiTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        uiBot.start()
    }
    
    @MainActor
    func testProductsListByDefault() {
        XCTAssertExists(uiBot.productsScreen.productsHeader, "Products header not found")
    }
    
    @MainActor
    func testSortListAppearesOnClick() {
        let sortProductsScreen = uiBot.productsScreen.sort()
        XCTAssertExists(sortProductsScreen.view, "Sort view is not found")
    }
    
    @MainActor
    func testSortListDisappearsOnItemSelected() {
        let sortProductsScreen = uiBot.productsScreen.sort()
        let productsScreen = sortProductsScreen.waitUntilVisible().sortByNameAscending()
        
        XCTAssertExists(productsScreen.productsHeader, "Products header not found")
    }
}
