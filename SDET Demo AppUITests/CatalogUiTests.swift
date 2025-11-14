import XCTest

@MainActor
final class CatalogUiTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        uiBot.start()
        
        epic("UI")
        feature("Catalog")
    }
    
    func testProductsListByDefault() {
        story("Viewing the product list")
        id("TC-UI-CATALOG-01")
        
        XCTAssertExists(uiBot.productsScreen.productsHeader, "Products header not found")
    }
    
    func testSortListAppearesOnClick() {
        story("Sorting")
        id("TC-UI-CATALOG-02")
        
        let sortProductsScreen = uiBot.productsScreen.sort()
        XCTAssertExists(sortProductsScreen.view, "Sort view is not found")
    }
    
    func testSortListDisappearsOnItemSelected() {
        story("Sorting")
        id("TC-UI-CATALOG-02")
        let productsScreen = uiBot.productsScreen.sort().waitUntilVisible().sortByNameAscending()
        XCTAssertExists(productsScreen.productsHeader, "Products header not found")
    }
}
