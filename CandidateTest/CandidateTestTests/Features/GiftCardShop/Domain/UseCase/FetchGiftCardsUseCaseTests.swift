//
//  FetchGiftCardsUseCaseTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 15/11/2024.
//

import XCTest

@testable import CandidateTest

final class FetchGiftCardsUseCaseTests: XCTestCase {
    private var useCase: FetchGiftCardsUseCase!
    private var repository: MockGiftCardShopRepository!
    
    override func setUp() {
        repository = MockGiftCardShopRepository()
        useCase = FetchGiftCardsUseCaseImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
    }
    
    // MARK: - Successful Case
    
    func test_execute_whenSuccessful_shouldReturnGiftCards() async throws {
        // Arrange and Act
        let result = await useCase.execute()
        
        // Assert
        XCTAssertTrue(repository.isCalled, "Should call fetchGiftCards() in repository")
        switch result {
        case .success(let giftCards):
            XCTAssertFalse(giftCards.isEmpty, "Should return non-empty gift cards")
        case .failure(let error):
            XCTFail("Should not return an error: \(error)")
        }
    }
    
    // MARK: - Failure Case
    
    func test_execute_whenFailure_shouldReturnError() async throws {
        // Arrange
        repository = MockGiftCardShopRepository(isSuccessful: false)
        useCase = FetchGiftCardsUseCaseImpl(repository: repository)
        
        // Act
        let result = await useCase.execute()
        
        // Assert
        XCTAssertTrue(repository.isCalled, "Should call fetchGiftCards() in repository")
        switch result {
        case .success(let giftCards):
            XCTAssertTrue(giftCards.isEmpty, "Should return empty gift cards")
        case .failure(let error):
            XCTAssertNotNil(error, "Should return an error")
        }
    }
}
