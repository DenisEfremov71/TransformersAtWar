//
//  TransformersAtWarUITests.swift
//  TransformersAtWarUITests
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import XCTest
import Alamofire

class TransformersAtWarUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTransformersList() {
        let app = XCUIApplication()
        let transformerCell = app.cells["cellTransformer0"]
        let label = app.staticTexts["Name"]
        let exists = NSPredicate(format: "exists == 1")
        
        transformerCell.tap()
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 1.0, handler: nil)
    }

}
