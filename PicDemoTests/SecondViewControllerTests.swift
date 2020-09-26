//
//  SecondViewControllerTests.swift
//  PicDemoTests
//
//  Created by ko on 2020/9/26.
//  Copyright © 2020 SM. All rights reserved.
//

import XCTest
@testable import PicDemo
class SecondViewControllerTests: XCTestCase {

    var secondVC: SecondViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        secondVC = SecondViewController.init(nibName: nil, bundle: nil)
        self.secondVC.loadView()
        self.secondVC.viewDidLoad()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        self.secondVC = nil
        try! super.tearDownWithError()
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: -  Collectionview tests
    func testThatViewConformsToUICollectionviewDataSource() {
        XCTAssertTrue(self.secondVC.conforms(to: UICollectionViewDataSource.self),"View does not conform to UICollectionview datasource protocol")
    }
    
    func testThatCollectionViewHasDataSource() {
        XCTAssertNotNil(self.secondVC.collectionView.dataSource, "Table datasource cannot be nil")
    }

    func testConformsToCollectionViewDataSource() {
        XCTAssertTrue(self.secondVC.responds(to: #selector(self.secondVC.collectionView(_:numberOfItemsInSection:))))
        XCTAssertTrue(self.secondVC.responds(to: #selector(self.secondVC.collectionView(_:cellForItemAt:))))
    }
    

    
    func testCollectionViewCellCreateCellsWithReuseIdentifier() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        self.secondVC.collectionView.register(ItemCell.self, forCellWithReuseIdentifier: self.secondVC.cellID)

        let cell = self.secondVC.collectionView.dequeueReusableCell(withReuseIdentifier: self.secondVC.cellID, for: indexPath)
        XCTAssertTrue(cell.reuseIdentifier == self.secondVC.cellID)
    }

    
    func test_cell() {
         
        let fakeJsonData : [[String : Any]] = [
            [
                "albumId": 1,
                "id": 2,
                "title": "reprehenderit est deserunt velit ipsam",
                "url": "https://via.placeholder.com/600/771796",
                "thumbnailUrl": "https://via.placeholder.com/150/771796"
            ]
           
        ]
        
        do {
         
            let data = try JSONSerialization.data(withJSONObject: fakeJsonData, options: .prettyPrinted) //try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
           let decoder = JSONDecoder()
           let decodePhotos = try decoder.decode([Photo].self, from: data)
 
            XCTAssertTrue(decodePhotos.count > 0, "List Data cannot be nil")
            
            let viewmodel = PhotoViewModel(photos: decodePhotos)
            self.secondVC.photoViewmodel = viewmodel
            
            XCTAssertTrue(decodePhotos.count > 0, "List Data cannot be nil")
            
            let indexPath = IndexPath(item: 0, section: 0)
            let cell = self.secondVC.collectionView.dataSource?.collectionView(self.secondVC.collectionView, cellForItemAt: indexPath) as! ItemCell
            
           
            XCTAssertEqual(cell.titleLabel.text!, "reprehenderit est deserunt velit ipsam")
        } catch let error {
            print(error.localizedDescription)
        }
 
    }
    
}
