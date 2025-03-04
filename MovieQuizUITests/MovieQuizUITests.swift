//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Валерий on 02.03.2025.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testYesButton() {
        let exists = NSPredicate(format: "exists == true")
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        expectation(for: exists, evaluatedWith: firstPoster, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        app.buttons["Yes"].tap()
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        expectation(for: exists, evaluatedWith: secondPoster, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        let exists = NSPredicate(format: "exists == true")
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        expectation(for: exists, evaluatedWith: firstPoster, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        app.buttons["No"].tap()
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        expectation(for: exists, evaluatedWith: secondPoster, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(firstPosterData == secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testGameFinish() {
        sleep(2)
        for _ in 0..<10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 0..<10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
