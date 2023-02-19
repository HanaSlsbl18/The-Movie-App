//
//  The_Movie_App_UITest.swift
//  The Movie App UITest
//
//  Created by Hana Salsabila on 19/02/23.
//

import XCTest

final class The_Movie_App_UITest: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testScrollingHomeTabBar() {
        app.tabBars.buttons["Home"].tap()
        let firstCell = app.cells.element(boundBy: 0)
        let secondCell = app.cells.element(boundBy: 3)
        let start1 = firstCell.coordinate(withNormalizedOffset: CGVectorMake(0, 0))
        let start2 = secondCell.coordinate(withNormalizedOffset: CGVectorMake(0, 0))
        let finish1 = firstCell.coordinate(withNormalizedOffset: CGVectorMake(0, -5))
        let finish2 = secondCell.coordinate(withNormalizedOffset: CGVectorMake(0, 2))
        
        start1.press(forDuration: 0, thenDragTo: finish1)
        start2.press(forDuration: 0, thenDragTo: finish2)
        app.waitForExistence(timeout: 5.0)
    }
    
    func testTapCellShow() {
        let firstCell = app.cells.element(boundBy: 0)
        let start = firstCell.coordinate(withNormalizedOffset: CGVectorMake(0, 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVectorMake(0, -3))
        
        app.tabBars.buttons["Home"].tap()
        start.press(forDuration: 0, thenDragTo: finish)
        
        app.waitForExistence(timeout: 5.0)
        app.tables.element(boundBy: 0).cells.element(boundBy: 0).collectionViews.cells.element(boundBy: 1).tap()
        start.press(forDuration: 0, thenDragTo: finish)
        
        app.waitForExistence(timeout: 5.0)
        app.navigationBars.buttons["Back"].tap()
    }
    
    func testComingSoonTabBarShow() {
        app.tabBars.buttons["Coming Soon"].tap()
        app.waitForExistence(timeout: 5.0)
        app.tables.cells.element(boundBy: 1).tap()
        app.navigationBars.buttons["Back"].tap()
    }
    
    func testTopSearchTabBarShow() {
        app.tabBars.buttons["Top Search"].tap()
        app.waitForExistence(timeout: 5.0)
        app.tables.cells.element(boundBy: 1).tap()
        app.navigationBars.buttons["Back"].tap()
    }
    
    func testEnterTextInSearchBar() {
        let firstCell = app.cells.element(boundBy: 0)
        let start = firstCell.coordinate(withNormalizedOffset: CGVectorMake(0, 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVectorMake(0, 3))
        
        app.tabBars.buttons["Top Search"].tap()
        start.press(forDuration: 0, thenDragTo: finish)

        app.searchFields.element.tap()
        app.searchFields.element.typeText("Harry Potter")
        app.waitForExistence(timeout: 10.0)
        app.collectionViews.cells.element(boundBy: 1).tap()
        app.waitForExistence(timeout: 10.0)
        app.navigationBars.buttons["Back"].tap()
    }
    
    func testApiCallCompletes() throws {
        let API_KEY = "4f0d3bb5fa69fc4aab6f6555a53f2775"
        let baseURL = "https://api.themoviedb.org"
        let urlString = "\(baseURL)/3/trending/movie/day?api_key=\(API_KEY)"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        let dataTask = URLSession.shared.dataTask(with: url) { results, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)

        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }


    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
