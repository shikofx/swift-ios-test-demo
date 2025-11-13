import XCTest
import SnapshotTesting
@testable import SDET_Demo_App

final class ProductPageDetailSnapshotTests: BaseSnapshotTest {

    var detailVC: ProductPageDetailViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        detailVC = storyboard.instantiateViewController(withIdentifier: "ProductPageDetailViewController") as? ProductPageDetailViewController

        // Configure VC with mock data
        detailVC.productImageName = "SauceLabsBackpack Image"
        detailVC.productName = "Sauce Labs Backpack"
        detailVC.productPrice = "29.99"
        detailVC.productHighlights = "carry.allTheThings() with the sleek, streamlined Sly Pack that melds uncompromising style with unequaled laptop and tablet protection."
        detailVC.productId = "1"

        detailVC.loadViewIfNeeded()
    }

    override func tearDown() {
        detailVC = nil
        super.tearDown()
    }

    func testDefaultState() {
        assertSnapshots(of: detailVC, as: .image)
    }

    func testBlackColorSelected() {
        detailVC.blackButton(UIButton())
        assertSnapshots(of: detailVC, as: .image)
    }

    func testBlueColorSelected() {
        detailVC.blueButton(UIButton())
        assertSnapshots(of: detailVC, as: .image)
    }

    func testIncreasedQuantity() {
        detailVC.addButton(UIButton())
        detailVC.addButton(UIButton())
        assertSnapshots(of: detailVC, as: .image)
    }

    func testZeroQuantity() {
        // Decrease quantity to 0
        detailVC.subtractButton(UIButton())
        assertSnapshots(of: detailVC, as: .image)
    }

}
