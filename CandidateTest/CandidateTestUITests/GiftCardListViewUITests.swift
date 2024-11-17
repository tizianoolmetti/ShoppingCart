//
//  GiftCardListViewUITests.swift
//  CandidateTestUITests
//
//  Created by Tom Olmetti on 16/11/2024.
//

import XCTest

final class GiftCardListViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func test_whenSuccessful_shouldDisplayGiftCards() {
        let title = app.staticTexts["Hey there"]
        let scrollViewTitle = app.scrollViews
        let element = app.scrollViews.otherElements.containing(.staticText, identifier:"Gift Cards for You").children(matching: .other).element
        let cartButton = app.buttons["cartButtonIdentifier"]
        
        // Assert
        XCTAssertTrue(title.exists)
        XCTAssertTrue(scrollViewTitle.staticTexts["Gift Cards for You"].exists)
        XCTAssertTrue(element.exists)
        XCTAssertTrue(cartButton.exists)
        XCTAssertTrue(cartButton.isEnabled)
    }
    
    func test_whenTapOnDetailsButton_shouldDisplayDetailView() {
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Gift Cards for You").children(matching: .other).element
        element.tap()
        
        let detailsButton = element.children(matching: .button).matching(identifier: "Details").element(boundBy: 0)
        detailsButton.tap()
        let xmarkButton = app.buttons["Close"]
        let cartButton = app.buttons["cartButtonIdentifier"]
        let elementsQuery = scrollViewsQuery.otherElements
        let termsAndConditionsButton = elementsQuery.buttons["Terms and Conditions"]
        let howToUseButton = elementsQuery.buttons["How to Use"]
        let addCartButton = app.buttons["Add to Cart (0), $0.00"]
        let buyNowButton = app.buttons["Buy Now $0.00"]
        
        // Assert
        XCTAssertTrue(xmarkButton.exists)
        XCTAssertTrue(cartButton.exists)
        XCTAssertTrue(termsAndConditionsButton.exists)
        XCTAssertTrue(howToUseButton.exists)
        XCTAssertTrue(addCartButton.exists)
        XCTAssertTrue(buyNowButton.exists)
    }
}
