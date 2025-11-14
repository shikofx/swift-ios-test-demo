import XCTest
import SnapshotTesting
@testable import SDET_Demo_App

final class ProductPageDetailSnapshotTests: BaseSnapshotTest {

    var detailVC: ProductPageDetailViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        
        epic("Snapshot")
        feature("Product Details")
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
        story("Default state")
        given("the product detail screen is opened") { _ in
            // View is configured in setUp
        }
        then("it should match the snapshot for the default state") { _ in
            assertSnapshots(of: detailVC, as: .image)
        }
    }

    func testBlackColorSelected() {
        story("Color selection")
        when("the user selects the black color") { _ in
            detailVC.blackButton(UIButton())
        }
        then("it should match the snapshot with the black color selected") { _ in
            assertSnapshots(of: detailVC, as: .image)
        }
    }

    func testBlueColorSelected() {
        story("Color selection")
        when("the user selects the blue color") { _ in
            detailVC.blueButton(UIButton())
        }
        then("it should match the snapshot with the blue color selected") { _ in
            assertSnapshots(of: detailVC, as: .image)
        }
    }

    func testIncreasedQuantity() {
        story("Quantity change")
        when("the user increases the quantity twice") { _ in
            detailVC.addButton(UIButton())
            detailVC.addButton(UIButton())
        }
        then("it should match the snapshot with a quantity of 3") { _ in
            assertSnapshots(of: detailVC, as: .image)
        }
    }

    func testZeroQuantity() {
        story("Quantity change")
        when("the user decreases the quantity to 0") { _ in
            detailVC.subtractButton(UIButton())
        }
        then("it should match the snapshot with a quantity of 0") { _ in
            assertSnapshots(of: detailVC, as: .image)
        }
    }

}
