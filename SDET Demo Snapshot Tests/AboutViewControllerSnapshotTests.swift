//
//  AboutViewControllerSnapshotTests.swift
//  SDET Demo Snapshot Tests
//
//  Created by Gemini Code Assist on 2025-11-13.
//

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
        given("the About screen is opened with an empty cart") { _ in
            // Cart is empty by default
            aboutVC.loadViewIfNeeded()
        }

        when("the view is presented") { _ in
            // No action needed, view is already loaded
        }

        then("it should match the snapshot for the default state") { _ in
            assertSnapshots(of: aboutVC, as: .image)
        }
    }

    func testWithItemsInCart() {
        given("the cart has 5 items") { _ in
            Engine.sharedInstance.cartCount = 5
            aboutVC.loadViewIfNeeded() // viewDidLoad will be called and update the label
        }

        then("it should match the snapshot with the cart badge visible") { _ in
            assertSnapshots(of: aboutVC, as: .image)
        }
    }
}