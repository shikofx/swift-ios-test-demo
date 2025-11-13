import XCTest
import SnapshotTesting
@testable import SDET_Demo_App

final class CatalogSnapshotTests: BaseSnapshotTest {

    var catalogVC: CatalogViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        catalogVC = storyboard.instantiateViewController(withIdentifier: "CatalogViewController") as? CatalogViewController
        catalogVC.loadViewIfNeeded()
    }

    override func tearDown() {
        catalogVC = nil
        super.tearDown()
    }

    func testDefaultState() {
        given("the Catalog screen is opened") { _ in
            // View is loaded in setUp
        }
        then("it should match the snapshot for the default state") { _ in
            assertSnapshots(of: catalogVC, as: .image)
        }
    }

    func testSortByNameDescending() {
        when("the user sorts by name descending") { _ in
            catalogVC.nameDescendingButton(UIButton())
        }
        then("it should match the snapshot with items sorted by name descending") { _ in
            assertSnapshots(of: catalogVC, as: .image)
        }
    }

    func testSortByPriceAscending() {
        when("the user sorts by price ascending") { _ in
            catalogVC.priceAscendingButton(UIButton())
        }
        then("it should match the snapshot with items sorted by price ascending") { _ in
            assertSnapshots(of: catalogVC, as: .image)
        }
    }

    func testSortByPriceDescending() {
        when("the user sorts by price descending") { _ in
            catalogVC.priceDescendingButton(UIButton())
        }
        then("it should match the snapshot with items sorted by price descending") { _ in
            assertSnapshots(of: catalogVC, as: .image)
        }
    }

    func testWithItemInCart() {
        given("the cart has 3 items") { _ in
            Engine.sharedInstance.cartCount = 3
            catalogVC.viewDidLoad() // Reload viewDidLoad to update the UI
        }
        then("it should match the snapshot with the cart badge visible") { _ in
            assertSnapshots(of: catalogVC, as: .image)
        }
    }
}