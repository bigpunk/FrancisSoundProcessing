//
//  FrancisSoundProcessingTests.swift
//  FrancisSoundProcessingTests
//
//  Created by rob on 10/23/17.
//  Copyright © 2017 KarmaHound. All rights reserved.
//

import XCTest
@testable import FrancisSoundProcessing

class FrancisSoundProcessingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testRollingWindow() {
        
        var rw = RollingWindow(windowSize: 100)
        
        var emptyWindow = rw.rollingWindowExtract(lookback: 2)
        XCTAssert(emptyWindow.count == 2)
        XCTAssert(emptyWindow[0] == 0.0)
        XCTAssert(emptyWindow[0] == 0.0)
        
        rw.updateRollingWindow(val: 1.0)
        rw.updateRollingWindow(val: 2.0)

        let twoElementWindow = rw.rollingWindowExtract(lookback: 2)
        let testTwoElementWindow : [Double] = [2.0, 1.0]
        XCTAssert(twoElementWindow == testTwoElementWindow)
        
        let threeElementWindow = rw.rollingWindowExtract(lookback: 3)
        let testThreeElementWindow : [Double] = [2.0, 1.0, 0.0]
        XCTAssert(threeElementWindow == testThreeElementWindow)
        
        rw = RollingWindow(windowSize: 100)
        
        for i in stride(from: 1.0, through: 100.0, by: 1) {
            rw.updateRollingWindow(val: i)
        }
        
        let fiveElements = rw.rollingWindowExtract(lookback: 5)
        let testFiveElements : [Double] = [100.0, 99.0, 98.0, 97.0, 96.0]
        XCTAssert(testFiveElements == fiveElements)
        
        rw.updateRollingWindow(val: 101.0)
        rw.updateRollingWindow(val: 102.0)

        let sevenElements = rw.rollingWindowExtract(lookback: 7)
        let testSevenElements : [Double] = [102.0, 101.0, 100.0, 99.0, 98.0, 97.0, 96.0]
        XCTAssert(sevenElements == testSevenElements)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
