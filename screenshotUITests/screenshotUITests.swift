//
//  screenshotUITests.swift
//  screenshotUITests
//
//  Created by kouchi.rin on 2020/05/21.
//  Copyright © 2020 kouchi.rin. All rights reserved.
//

import XCTest

class screenshotUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        takeScreenshot(name: "first")

        let button = app.buttons["ToSecondButton"]
        button.tap()

        let exp = expectation(description: "Screen Loaded")
        if XCTWaiter.wait(for: [exp], timeout: 0.5) == .timedOut {
            takeScreenshot(name: "second")
        }
    }

    func takeScreenshot(name: String) {
      let fullScreenshot = XCUIScreen.main.screenshot()

      let screenshot = XCTAttachment(uniformTypeIdentifier: "public.png", name: "Screenshot-\(name)-\(UIDevice.current.name).png", payload: fullScreenshot.pngRepresentation, userInfo: nil)
      screenshot.lifetime = .keepAlways
      add(screenshot)
    }
}
