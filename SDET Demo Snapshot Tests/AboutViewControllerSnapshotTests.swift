import XCTest
import SnapshotTesting
@testable import SDET_Demo_App

final class AboutViewControllerSnapshotTests: BaseSnapshotTest {

    var aboutVC: AboutViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        aboutVC = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController
    }

    override func tearDown() {
        aboutVC = nil
        // Reset cart state
        Engine.sharedInstance.cartCount = 0
        super.tearDown()
    }

    func testDefaultState() {
        // Cart is empty by default
        aboutVC.loadViewIfNeeded()

        assertSnapshots(of: aboutVC, as: .image)
    }

    func testWithItemsInCart() {
        Engine.sharedInstance.cartCount = 5
        aboutVC.loadViewIfNeeded() // viewDidLoad will be called and update the label
        assertSnapshots(of: aboutVC, as: .image)
    }
}
