//
//  QuickShopUITestsLaunchTests.swift
//  QuickShopUITests
//
//  Created by Marcin Wawer on 10-05-2025.
//

import XCTest

final class QuickShopUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--reset-state")
        app.launch()
        
        let browseTab = app.tabBars.buttons["Browse Products"]
        XCTAssertTrue(browseTab.waitForExistence(timeout: 5), "The Browse tab should be present immediately after launch.")

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
