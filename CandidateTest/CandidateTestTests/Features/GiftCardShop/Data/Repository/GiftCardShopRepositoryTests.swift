//
//  GiftCardShopRepositoryTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 15/11/2024.
//

import XCTest

@testable import CandidateTest

final class GiftCardShopRepositoryTests: XCTestCase {
    private var repository: GiftCardShopRepository!
    private var dataSource: MockGiftCardShopDataSource!
    
    private let test_id = "0f3f7b67-6f75-4f0b-9ed9-b746c2eb0bd6"
    
    override func setUp() {
        dataSource = MockGiftCardShopDataSource()
        repository = GiftCardShopRepositoryImpl(dataSource: dataSource)
    }
    
    override func tearDown() {
        dataSource = nil
        repository = nil
    }
    
    // MARK: - Fetch Gift Cards
    
    func test_fetchGiftCards_whenSuccessful_shouldReturnGiftCards() async throws {
        // Arrange and Act
        let result = await repository.fetchGiftCards()
        
        // Assert
        XCTAssertTrue(dataSource.isCalled, "Should call fetchGiftCards() in data source")
        switch result {
        case .success(let giftCards):
            XCTAssertFalse(giftCards.isEmpty, "Should return non-empty gift cards")
        case .failure(let error):
            XCTFail("Should not return an error: \(error)")
        }
    }
    
    func test_fetchGiftCards_whenFailure_shouldReturnError() async throws {
        // Arrange
        dataSource = MockGiftCardShopDataSource(isSuccessful: false)
        repository = GiftCardShopRepositoryImpl(dataSource: dataSource)
        
        // Act
        let result = await repository.fetchGiftCards()
        
        // Assert
        XCTAssertTrue(dataSource.isCalled, "Should call fetchGiftCards() in data source")
        switch result {
        case .success(let giftCards):
            XCTAssertTrue(giftCards.isEmpty, "Should return empty gift cards")
        case .failure(let error):
            XCTAssertNotNil(error, "Should return an error")
        }
    }
    
    // MARK: - Fetch Gift Card
    
    func test_fetchGiftCard_whenSuccessful_shouldReturnGiftCard() async throws {
        // Arrange and  Act
        let result = await repository.fetchGiftCard(id: test_id)
        
        // Assert
        XCTAssertTrue(dataSource.isCalled, "Should call fetchGiftCard() in data source")
        switch result {
        case .success(let giftCard):
            XCTAssertEqual(giftCard.id, test_id, "Should return the correct gift card")
        case .failure(let error):
            XCTFail("Should not return an error: \(error)")
        }
    }
    
    func test_fetchGiftCard_whenFailure_shouldReturnError() async throws {
        // Arrange
        dataSource = MockGiftCardShopDataSource(isSuccessful: false)
        repository = GiftCardShopRepositoryImpl(dataSource: dataSource)
        
        // Act
        let result = await repository.fetchGiftCard(id: test_id)
        
        // Assert
        XCTAssertTrue(dataSource.isCalled, "Should call fetchGiftCard() in data source")
        switch result {
        case .success(let giftCard):
            XCTAssertNil(giftCard, "Should not return a gift card")
        case .failure(let error):
            XCTAssertNotNil(error, "Should return an error")
        }
    }
}
