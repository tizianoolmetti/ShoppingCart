//
//  ShoppingCartViewModelTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 16/11/2024.
//

import XCTest

import XCTest
@testable import CandidateTest


final class ShoppingCartViewModelTests: XCTestCase {
    var viewModel: ShoppingCartViewModel!
    var mockBuyGiftCardUseCase: MockBuyGiftCardUseCase!

    override func setUp() {
        super.setUp()
        mockBuyGiftCardUseCase = MockBuyGiftCardUseCase()
        viewModel = ShoppingCartViewModel(buyGiftCardUseCase: mockBuyGiftCardUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockBuyGiftCardUseCase = nil
        super.tearDown()
    }

    func test_shoudAddGiftCardToTheShoppingCart_whenGiftCardIsAdded() {
        // Arrange and Act
        viewModel.add(giftCard: GiftCard.kmartCard, denominations: [Denomination.mockDenomination()])
        
        // Assert
        XCTAssertEqual(viewModel.itemCount, 1)
        XCTAssertEqual(viewModel.totalAmount, 10)
        XCTAssertTrue(viewModel.hasItems)
    }

    func test_shoudRemoveGiftCardFromTheShoppingCart_whenGiftCardIsRemoved() {
        // Arrange and Act
        viewModel.add(giftCard: GiftCard.kmartCard, denominations: [Denomination.mockDenomination()])
        
        // Assert
        XCTAssertEqual(viewModel.itemCount, 1)
        
        //Act
        viewModel.remove(giftCardId: GiftCard.kmartCard.brand)
        
        // Assert
        XCTAssertEqual(viewModel.itemCount, 0)
        XCTAssertFalse(viewModel.hasItems)
    }

    func test_shoudClearTheShoppingCart_whenRemoveAllIsCalled() {
        // Arrange and Act
        viewModel.add(giftCard: GiftCard.kmartCard, denominations: [Denomination.mockDenomination()])
        viewModel.add(giftCard: GiftCard.uberEatsCard, denominations: [Denomination.mockDenomination()])
        
        // Assert
        XCTAssertEqual(viewModel.itemCount, 2)
        XCTAssertEqual(viewModel.totalAmount, 20.0)
        
        //Act
        viewModel.clear()
        
        // Assert
        XCTAssertEqual(viewModel.itemCount, 0)
        XCTAssertEqual(viewModel.totalAmount, 0.0)
        XCTAssertFalse(viewModel.hasItems)
    }

    func test_shouldResetItemCountAndAmount_whenCheckoutIsCalled() async {
        viewModel.add(giftCard: GiftCard.kmartCard, denominations: [Denomination.mockDenomination()])
        await viewModel.checkout()
        
        XCTAssertEqual(viewModel.itemCount, 0)
        XCTAssertEqual(viewModel.totalAmount, 0.0)
        XCTAssertFalse(viewModel.hasItems)
    }
}