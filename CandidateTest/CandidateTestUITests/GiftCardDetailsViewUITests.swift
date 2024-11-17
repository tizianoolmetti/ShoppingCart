//
//  GiftCardDetailsViewUITests.swift
//  CandidateTestUITests
//
//  Created by Tom Olmetti on 16/11/2024.
//

import XCTest

final class GiftCardDetailsViewUITests: XCTestCase {
    
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
    
    func test_whenGiftCardIsSelcted_ButtonSectionIsEnableb() {
        
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Gift Cards for You").children(matching: .other).element
        element.children(matching: .image).element(boundBy: 0).tap()
        element.children(matching: .button).matching(identifier: "Details").element(boundBy: 0).tap()
        scrollViewsQuery.otherElements.buttons["50, AUD"].tap()
        let addCartButton = app.buttons["Add to Cart (1), $50.00"]
        let buyNowButton = app.buttons["Buy Now $50.00"]
        
        XCTAssertTrue(addCartButton.isEnabled)
        XCTAssertTrue(addCartButton.isHittable)
        XCTAssertTrue(buyNowButton.isEnabled)
        XCTAssertTrue(buyNowButton.isHittable)
    }
    
    
    func test_whenAddCartButtonIsTapped_cartButtonShoulBeUpdated() {
        
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Gift Cards for You").children(matching: .other).element.children(matching: .button).matching(identifier: "Details").element(boundBy: 0).tap()
        scrollViewsQuery.otherElements.buttons["50, AUD"].tap()
        app.buttons["Add to Cart (1), $50.00"].tap()
        let cartButton = app.buttons["cartButtonIdentifier"]
        
        //Assert
        XCTAssertTrue(cartButton.exists)
        
        
        let addCartButton = app.buttons["Add to Cart (0), $0.00"]
        let buyNowButton = app.buttons["Buy Now $0.00"]
        
        //Assert
        XCTAssertTrue(addCartButton.exists)
        XCTAssertTrue(buyNowButton.exists)
    }
    
    func test_whenBuyNowIsTapped_confirmationViewShouldBeDisplayed() {
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Gift Cards for You").children(matching: .other).element.children(matching: .button).matching(identifier: "Details").element(boundBy: 0).tap()
        scrollViewsQuery.otherElements.buttons["50, AUD"].tap()
        let buyNowButton = app.buttons["Buy Now $50.00"]
        buyNowButton.tap()
        
        let title = app.staticTexts["Purchase Successful!"]
        let message = app.staticTexts["Your gift card will be delivered to your email shortly."]
        let doneButton = app.buttons["Done"]
        
        sleep(2)
        //Assert
        XCTAssertTrue(title.exists)
        XCTAssertTrue(message.exists)
        
        doneButton.tap()
        
        //Assert
        XCTAssertFalse(title.exists)
        XCTAssertFalse(message.exists)
    }
}

