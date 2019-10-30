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
        let transformerCell = app.cells["transformerCell0"]
        let label = app.staticTexts["Name"]
        let exists = NSPredicate(format: "exists == 1")
        
        transformerCell.tap()
        expectation(for: exists, evaluatedWith: label, handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testPerformance() {
        self.measure {
            
            let app = XCUIApplication()
            let overallRating36StaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Overall rating: 36"]/*[[".cells[\"transformerCell0\"].staticTexts[\"Overall rating: 36\"]",".staticTexts[\"Overall rating: 36\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            overallRating36StaticText.tap()
            
            let element = app.otherElements.containing(.navigationBar, identifier:"Transformer Details").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
            element.children(matching: .other).element(boundBy: 0).children(matching: .textField).element.tap()
            
            let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            deleteKey.tap()
            deleteKey.tap()
            deleteKey.tap()
            
            let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            aKey.tap()
            aKey.tap()
            element.children(matching: .other).element(boundBy: 1).children(matching: .textField).element.tap()
            deleteKey.tap()
            deleteKey.tap()
            
            let aKey2 = app/*@START_MENU_TOKEN@*/.keys["A"]/*[[".keyboards.keys[\"A\"]",".keys[\"A\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            aKey2.tap()
            element.children(matching: .other).element(boundBy: 2).sliders["44%"].swipeLeft()
            app.navigationBars["Transformer Details"].buttons["Transformers at War"].tap()
            
        }
    }

}
