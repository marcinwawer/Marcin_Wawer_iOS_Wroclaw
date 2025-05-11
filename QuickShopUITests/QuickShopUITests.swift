//
//  QuickShopUITests.swift
//  QuickShopUITests
//
//  Created by Marcin Wawer on 10-05-2025.
//

import XCTest

final class QuickShopUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--reset-state")
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    @MainActor
    func testBrowseTabIsDefaultAndShowsProducts() throws {
        let browseButton = app.tabBars.buttons["Browse Products"]
        XCTAssertTrue(browseButton.isSelected)
        
        let firstCell = app.scrollViews
            .containing(.staticText, identifier: "Organic Fair Trade Coffee Beans")
            .firstMatch
        
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Expected to see the Coffee Beans product on Browse screen")
    }
    
    @MainActor
    func testSortingByPriceChangesVisualOrder() throws {
        let browseTab = app.tabBars.buttons["Browse Products"]
        browseTab.tap()
        
        let coffeeLabel = app.staticTexts["Organic Fair Trade Coffee Beans"]
        let bottleLabel = app.staticTexts["Stainless Steel Water Bottle"]
        XCTAssertTrue(coffeeLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(bottleLabel.waitForExistence(timeout: 5))
        
        let sortPrice = app.buttons.matching(identifier: "Sort by price").firstMatch
        XCTAssertTrue(sortPrice.exists)
        sortPrice.tap()
        
        let coffeeYAsc = coffeeLabel.frame.minY
        let bottleYAsc = bottleLabel.frame.minY
        XCTAssertLessThan(coffeeYAsc, bottleYAsc, "Coffee Beans should appear above Water Bottle in ascending order")
        
        sortPrice.tap()
        sleep(1)
        
        let coffeeYDesc = coffeeLabel.frame.minY
        let bottleYDesc = bottleLabel.frame.minY
        XCTAssertLessThan(bottleYDesc, coffeeYDesc, "Water Bottle should appear above Coffee Beans in descending order")
    }
    
    @MainActor
    func testAdjustQuantityAndTotalPriceUpdates() throws {
        app.tabBars.buttons["Browse Products"].tap()
        
        let increaseButton = app.buttons
            .matching(identifier: "IncreaseQuantityButton")
            .firstMatch
        
        increaseButton.tap()
        
        let total = app.staticTexts["Total price in cart"]
        XCTAssertTrue(total.waitForExistence(timeout: 2))
        XCTAssertFalse(total.label.contains("0.00"))
    }
    
    @MainActor
    func testCheckoutTabShowsEmptyCartAndThenCartItems() throws {
        let checkoutTab = app.tabBars.buttons["Order Products"]
        checkoutTab.tap()
        
        let emptyMessage = app.staticTexts["Your cart is empty 😭"]
        XCTAssertTrue(emptyMessage.waitForExistence(timeout: 2))
        
        app.tabBars.buttons["Browse Products"].tap()
        let increaseButton = app.buttons
            .matching(identifier: "IncreaseQuantityButton")
            .firstMatch
        XCTAssertTrue(increaseButton.waitForExistence(timeout: 5))
        
        increaseButton.tap()
        
        checkoutTab.tap()
        sleep(1)
        
        XCTAssertFalse(emptyMessage.exists, "Empty‐cart message should disappear once there's an item")
        
        let placeOrder = app.buttons["Checkout"]
        XCTAssertTrue(placeOrder.waitForExistence(timeout: 2))
        
        let value = placeOrder.value as? String
        XCTAssertTrue(
            value?.contains("Organic Fair Trade Coffee Beans: 1") == true,
            "Checkout button should list the cart contents in its value"
        )
    }
}
