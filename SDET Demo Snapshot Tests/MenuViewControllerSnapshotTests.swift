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
        given("the user is logged out") { _ in
            Engine.sharedInstance.isLogin = false
            menuVC.loadViewIfNeeded() // viewDidLoad() will be called here
        }
        then("it should match the snapshot for the logged out state") { _ in
            assertSnapshots(of: menuVC, as: .image)
        }
    }

    func testLoggedInState() {
        given("the user is logged in") { _ in
            Engine.sharedInstance.isLogin = true
            menuVC.loadViewIfNeeded() // viewDidLoad() will be called here
        }
        then("it should match the snapshot for the logged in state") { _ in
            assertSnapshots(of: menuVC, as: .image)
        }
    }
}
