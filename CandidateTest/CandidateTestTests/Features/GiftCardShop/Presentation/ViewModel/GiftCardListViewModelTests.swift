//
//  GiftCardListViewModelTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 15/11/2024.
//

import XCTest

@testable import CandidateTest

final class GiftCardListViewModelTests: XCTestCase {
    private var viewModel: GiftCardListViewModel!
    private var mockFetchGiftCardsUseCase: MockFetchGiftCardsUseCase!
    
    override func setUp() {
        mockFetchGiftCardsUseCase = MockFetchGiftCardsUseCase()
        viewModel = GiftCardListViewModel(fetchGiftCardsUseCase: mockFetchGiftCardsUseCase)
    }
    
    override func tearDown() {
        mockFetchGiftCardsUseCase = nil
        viewModel = nil
    }
    
    // MARK: - Fetch Gift Cards
    
    func test_fetchGiftCards_whenSuccessful_shouldUpdateState() async {
        // Arrange
        mockFetchGiftCardsUseCase = MockFetchGiftCardsUseCase(isSuccessful: true)
        viewModel = GiftCardListViewModel(fetchGiftCardsUseCase: mockFetchGiftCardsUseCase)
        
        // Act
        await viewModel.fetchGiftCards()
        
        // Assert
        XCTAssertTrue(mockFetchGiftCardsUseCase.isCalled, "Should call execute() on the use case")
        XCTAssertEqual(viewModel.giftCards.count, GiftCard.mockCards.count, "Should update the state with the expected gift cards")
        XCTAssertEqual(viewModel.giftCards.first?.id, GiftCard.mockCards.first?.id, "Should update the state with the expected gift cards")
        XCTAssertFalse(viewModel.isLoading, "Should set isLoading to false after fetching")
        XCTAssertNil(viewModel.error, "Should not have an error")
    }
    
    func test_fetchGiftCards_whenFailure_shouldUpdateState() async {
        // Arrange
        let mockError = NetworkError.invalidData
        mockFetchGiftCardsUseCase = MockFetchGiftCardsUseCase(isSuccessful: false, isCalled: false)
        viewModel = GiftCardListViewModel(fetchGiftCardsUseCase: mockFetchGiftCardsUseCase)
        
        // Act
        await viewModel.fetchGiftCards()
        
        // Assert
        XCTAssertTrue(mockFetchGiftCardsUseCase.isCalled, "Should call execute() on the use case")
        XCTAssertFalse(viewModel.isLoading, "Should set isLoading to false after fetching")
        XCTAssertEqual(viewModel.error?.localizedDescription, mockError.localizedDescription, "Should update the error in the state")
    }
}
