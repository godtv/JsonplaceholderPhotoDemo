//
//  FirstViewControllerTests.swift
//  PicDemoUITests
//
//  Created by ko on 2020/9/26.
//  Copyright © 2020 SM. All rights reserved.
//

import XCTest
import Alamofire
import Combine

@testable import PicDemo

class FirstViewControllerTests: XCTestCase {
    
    var firstVC: FirstViewController!
     
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try! super.setUpWithError()
        firstVC = FirstViewController.init(nibName: nil, bundle: nil)
        self.firstVC.loadView()
        self.firstVC.viewDidLoad()
        
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.firstVC = nil
        try! super.tearDownWithError()
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
             
            callAPI(success: { (datas: Array, code: Int) in
                
            }) { (error, code ,desc) in
                
            }
            
        }
    }
    
 
    func testNextViewButton()
    {
    
        let nextViewButton: UIButton = firstVC.nextViewButton
        XCTAssertNotNil(nextViewButton, "View Controller does not have UIButton property")
 
    }
    
    func testNextViewButtonInvokesActionMethodWhenTapped() {
        
        let actionMethod = self.firstVC.nextViewButton.actions(forTarget: self.firstVC, forControlEvent: UIControl.Event.touchUpInside)
        let actualMethodName = actionMethod?.first
        let expectedMethodName = "toSecondViewController:"
        
        XCTAssertEqual(actualMethodName, expectedMethodName, "Actual: \(String(describing: actualMethodName)) not equal to expected: \(expectedMethodName)")
    }
    
    func testDoGetPhotos()
    {
        let ex = expectation(description: "Expecting a JSON data not nil")
        
        callAPI(success: { (datas: Array, code: Int) in
            XCTAssertNotNil(datas)
            ex.fulfill()
            
        }) { (error, code ,desc) in
            
            XCTAssertNil(error)
        }
        //TimeOut
        waitForExpectations(timeout: 15) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
        
    }
    
    func testStatusCode() {
        callAPI(success: { (datas: Array, code: Int) in
            switch code {
            case 200:
                XCTAssertEqual(code, 200, "status code was not 200")
            default:
                print("")
            }
            
        }) { (error, code ,desc) in
            
            switch code {
            //http 304 not modified
            case 304:
                XCTAssertEqual(code, 304, "status code was not 304")
            default:
                print("")
            }
            XCTAssertNil(error)
        }

    }
    
    func testImagePublisher()
    {
        let apiWorker = AllenRequestCenter.sharedInstance
        let url = APPURL.Jsonplaceholder
        let publisher: AnyPublisher<UIImage?, Never> =  apiWorker.imagePublisher(for: URL(string: url)!)
        XCTAssertNotNil(publisher)
    }
    
    //MARK: -- callWebAPI
    private func callAPI(success successCallback: @escaping (Array<Dictionary<String,Any>>, _ code: Int) -> (),
                         failure failureCallbac:@escaping (AFError, _ code: Int, _ desc: String) -> ()) {
        
        let apiWorker = AllenRequestCenter.sharedInstance
        firstVC.apiWorker = apiWorker
        
        let url = APPURL.Jsonplaceholder
        
        apiWorker.getDatasWithUrl(url: url) { (data: Array<Dictionary<String,Any>>, code: Int) in
            successCallback(data, code)
        } failure: { (error, code ,desc) in
            failureCallbac(error, code, desc)
        }
        
    }
    
 
    
}
