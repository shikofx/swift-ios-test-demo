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
        assertSnapshots(of: catalogVC, as: .image)
    }

    func testSortByNameDescending() {
        catalogVC.nameDescendingButton(UIButton())
        assertSnapshots(of: catalogVC, as: .image)
    }

    func testSortByPriceAscending() {
        catalogVC.priceAscendingButton(UIButton())
        assertSnapshots(of: catalogVC, as: .image)
    }

    func testSortByPriceDescending() {
        catalogVC.priceDescendingButton(UIButton())
        assertSnapshots(of: catalogVC, as: .image)
    }

    func testWithItemInCart() {
        Engine.sharedInstance.cartCount = 3
        // Reload viewDidLoad to update the UI
        catalogVC.viewDidLoad()
        assertSnapshots(of: catalogVC, as: .image)
        // Reset the state
        Engine.sharedInstance.cartCount = 0
    }

    func testRecursiveDescription() {
        assertSnapshot(of: catalogVC, as: .recursiveDescription)
    }
}