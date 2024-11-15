//
//  GiftCardShopDataSourceTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 15/11/2024.
//

import XCTest

@testable import CandidateTest

final class GiftCardShopDataSourceTests: XCTestCase {
    private var dataSource: GiftCardShopDataSourceImpl!
    private var networkService: MockNetworkService!
    
    private let test_id = "0f3f7b67-6f75-4f0b-9ed9-b746c2eb0bd6"
    
    override func setUp() {
        networkService = MockNetworkService()
        dataSource = GiftCardShopDataSourceImpl(service: networkService)
    }
    
    override func tearDown() {
        networkService = nil
        dataSource = nil
    }
    
    // MARK: - Fetch Gift Cards
    
    func test_fetchGiftCards_whenSuccessful_shouldReturnGiftCards() async throws {
        // Arrange
        let mockData = try JSONEncoder().encode(GiftCard.mockCards)
        networkService.addResponse(for: GiftCardsEndpoint.list, data: mockData)
        
        // Act
        let result =  await dataSource.fetchGiftCards()
        
        // Assert
        switch result {
        case .success(let giftCards):
            XCTAssertEqual(giftCards.count, GiftCard.mockCards.count, "Should return the expected number of gift cards")
        case .failure(let error):
            XCTFail("Should not return an error: \(error)")
        }
    }
    
    func test_fetchGiftCards_whenFailure_shouldReturnError() async throws {
        // Arrange
        let mockError = NetworkError.invalidResponse
        networkService.addError(for: GiftCardsEndpoint.list, error: mockError)
        
        // Act
        let result = await dataSource.fetchGiftCards()
        
        // Assert
        switch result {
        case .success(let giftCards):
            XCTAssertTrue(giftCards.isEmpty, "Should return empty gift cards")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, mockError.localizedDescription, "Should return the expected error")
        }
    }
    
    // MARK: - Fetch Gift Card
    
    func test_fetchGiftCard_whenSuccessful_shouldReturnGiftCard() async throws {
        // Arrange
        let mockData = try JSONEncoder().encode(GiftCard.kmartCard)
        networkService.addResponse(for: GiftCardsEndpoint.detail(id: test_id), data: mockData)
        
        // Act
        let result = await dataSource.fetchGiftCard(id: test_id )
        
        // Assert
        switch result {
        case .success(let giftCard):
            XCTAssertEqual(giftCard.id, test_id , "Should return the expected gift card")
        case .failure(let error):
            XCTFail("Should not return an error: \(error)")
        }
    }
    
    func test_fetchGiftCard_whenFailure_shouldReturnError() async throws {
        // Arrange
        let mockError = NetworkError.invalidResponse
        networkService.addError(for: GiftCardsEndpoint.detail(id: test_id ), error: mockError)
        
        // Act
        let result = await dataSource.fetchGiftCard(id: test_id )
        
        // Assert
        switch result {
        case .success(let giftCard):
            XCTAssertNil(giftCard, "Should not return a gift card")
        case .failure(let error):
            XCTAssertEqual(error.localizedDescription, mockError.localizedDescription, "Should return the expected error")
        }
    }
}
