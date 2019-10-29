//
//  AlamofireTests.swift
//  TransformersAtWarTests
//
//  Created by Denis Efremov on 2019-10-28.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import XCTest
import Alamofire
@testable import TransformersAtWar

class AlamofireTests: XCTestCase {
    
    var token: String?
    var headers: HTTPHeaders?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // get token from the testFetchToken first, if the other tests fail
        token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0cmFuc2Zvcm1lcnNJZCI6Ii1Mc0pyaXJCM01rdVZMaHYxbGdiIiwiaWF0IjoxNTcyMzA4MTg0fQ.w0gJjHrZPSxFAtEB5FHcTisgHqNvjtO5nkia7gBXU0w"
        headers = ["Content-Type": "application/json", "Authorization": "Bearer \(token ?? "no token")"]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
//    func testFetchToken() {
//        let e = expectation(description: "Alamofire")
//
//        Alamofire.request(Constants.ApiEndPoints.fetchToken).responseString { response in
//
//            XCTAssertNotNil(response, "No response")
//            XCTAssertNil(response.error, "Error \(response.error!.localizedDescription)")
//            XCTAssertEqual(response.response?.statusCode ?? 0, 200, "Status code not 200")
//            XCTAssertNotNil(response.value, "No token returned")
//
//            if let token = response.value {
//                self.token = token
//            }
//
//            e.fulfill()
//        }
//
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
    
    func testCreateNewTransformer() {
        let e = expectation(description: "Alamofire")
        
        let parameters: [String:Any] = ["name":"Air Raid", "team":"A", "strength":5, "intelligence":7, "speed":9,
                                        "endurance":7, "rank":5, "courage":10, "firepower":8, "skill":7]
        
        Alamofire.request(Constants.ApiEndPoints.createNewTransformer, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in

            XCTAssertNotNil(response, "No response")
            XCTAssertNil(response.error, "Error \(response.error!.localizedDescription)")
            XCTAssertEqual(response.response?.statusCode ?? 0, 201, "Status code not 201")
            XCTAssertNotNil(response.data, "No data returned")

            e.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetAllTransformers() {
        let e = expectation(description: "Alamofire")
        
        Alamofire.request(Constants.ApiEndPoints.fetchAllTransformers, headers: headers).responseJSON { response in
            
            XCTAssertNotNil(response, "No response")
            XCTAssertNil(response.result.error, "Error \(response.result.error!.localizedDescription)")
            XCTAssertEqual(response.response?.statusCode ?? 0, 200, "Status code not 200")
            XCTAssertNotNil(response.result.value, "No JSON returned")
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testGetSpecifcTransformer() {
        let e = expectation(description: "Alamofire")
        let url = Constants.ApiEndPoints.fetchSpecificTransformer + "/-LsK44-UhravMZ69naxj"

        Alamofire.request(url, headers: headers).responseJSON { response in

            XCTAssertNotNil(response, "No response")
            XCTAssertNil(response.result.error, "Error \(response.result.error!.localizedDescription)")
            XCTAssertEqual(response.response?.statusCode ?? 0, 200, "Status code not 200")
            XCTAssertNotNil(response.result.value, "No JSON returned")

            e.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testUpdateTransformer() {
        let e = expectation(description: "Alamofire")
        
        let parameters: [String : Any] = ["id":"-LsK0ykn2-5lrbmMJAHJ", "name":"Air Raid", "team":"A", "strength":5, "intelligence":7, "speed":9,
                          "endurance":7, "rank":5, "courage":10, "firepower":8, "skill":7]
        
        Alamofire.request(Constants.ApiEndPoints.updateTransformer, parameters: parameters, headers: headers).responseJSON { response in
            
            XCTAssertNotNil(response, "No response")
            XCTAssertNil(response.result.error, "Error \(response.result.error!.localizedDescription)")
            XCTAssertEqual(response.response?.statusCode ?? 0, 200, "Status code not 200")
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
//    func testDeleteTransformer() {
//        let e = expectation(description: "Alamofire")
//        let url = Constants.ApiEndPoints.deleteTransformer + "/-LsK44-UhravMZ69naxj"
//        
//        Alamofire.request(url, method: .delete, headers: headers).responseString { response in
//            
//            XCTAssertNotNil(response, "No response")
//            XCTAssertNil(response.result.error, "Error \(response.result.error!.localizedDescription)")
//            XCTAssertEqual(response.response?.statusCode ?? 0, 204, "Status code not 204")
//            
//            e.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
