import XCTest
import SnapshotTesting
@testable import SDET_Demo_App

final class MyCartViewControllerTests: BaseSnapshotTest {

    var cartVC: MyCartViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        
        epic("Snapshot")
        feature("Cart")
        cartVC = storyboard.instantiateViewController(withIdentifier: "MyCartViewController") as? MyCartViewController
    }

    override func tearDown() {
        cartVC = nil
        // Clear the cart after each test
        Engine.sharedInstance.cartList.removeAll()
        Engine.sharedInstance.cartCount = 0
        Engine.sharedInstance.totalPrice = 0.0
        super.tearDown()
    }

    func testEmptyCart() {
        story("Empty cart")
        given("the cart is empty") { _ in
            cartVC.loadViewIfNeeded()
        }
        then("it should match the snapshot for the empty cart state") { _ in
            assertSnapshots(of: cartVC, as: .image)
        }
    }

    func testWithOneItem() {
        story("Cart with one item")
        given("the cart has one item") { _ in
            addMockProduct(quantity: 1)
            cartVC.loadViewIfNeeded()
        }
        then("it should match the snapshot with one item in the cart") { _ in
            assertSnapshots(of: cartVC, as: .image)
        }
    }

    func testWithMultipleItems() {
        story("Cart with multiple items")
        given("the cart has multiple items") { _ in
            addMockProduct(id: "1", name: "Sauce Labs Backpack", quantity: 2)
            addMockProduct(id: "2", name: "Sauce Labs Bike Light", quantity: 1)
            cartVC.loadViewIfNeeded()
        }
        then("it should match the snapshot with multiple items in the cart") { _ in
            assertSnapshots(of: cartVC, as: .image)
        }
    }

    // Helper function to add products to the cart
    private func addMockProduct(id: String = "1", name: String = "Sauce Labs Backpack", quantity: Int) {
        let product: NSMutableDictionary = [
            "Id": id,
            "ProductImageName": "SauceLabsBackpack Image",
            "ProductName": name,
            "ProductPrice": "29.99",
            "ProductColor": "Red",
            "ProductQuantity": quantity
        ]
        Engine.sharedInstance.cartList.append(product)
        Engine.sharedInstance.cartCount += quantity
    }
}
