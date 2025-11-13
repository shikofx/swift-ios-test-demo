import XCTest
import SnapshotTesting
@testable import SDET_Demo_App

final class MenuViewControllerSnapshotTests: BaseSnapshotTest {

    var menuVC: MenuViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        menuVC = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as? MenuViewController
    }

    override func tearDown() {
        menuVC = nil
        // Reset login state
        Engine.sharedInstance.isLogin = false
        super.tearDown()
    }

    func testLoggedOutState() {
        Engine.sharedInstance.isLogin = false
        menuVC.loadViewIfNeeded() // viewDidLoad() will be called here
        assertSnapshots(of: menuVC, as: .image)
    }

    func testLoggedInState() {
        Engine.sharedInstance.isLogin = true
        menuVC.loadViewIfNeeded() // viewDidLoad() will be called here
        assertSnapshots(of: menuVC, as: .image)
    }
}
