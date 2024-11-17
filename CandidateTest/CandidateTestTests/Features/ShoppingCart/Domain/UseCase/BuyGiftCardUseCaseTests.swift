//
//  BuyGiftCardUseCaseTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 15/11/2024.
//

import XCTest

@testable import CandidateTest

final class BuyGiftCardUseCaseTests: XCTestCase {
    
    private var useCase: BuyGiftCardUseCase!
    private var repository: MockShoppingCartRepository!
    
    override func setUp() {
        repository = MockShoppingCartRepository()
        useCase = BuyGiftCardUseCaseImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
    }
    
    // MARK: - Successful Case
    func test_execute_whenSuccessful_shouldReturnOrderConfirmation() async throws {
        // Arrange
        let purchases = [
            GiftCardPurchase(
                giftCardId: "test-card-1",
                brand: "Test Brand",
                denominations: [
                    Denomination(price: 50.0, currency: "USD", stock: "IN_STOCK")
                ]
            )
        ]
        
        // Act
        let confirmation = try await useCase.execute(purchases: purchases)
        
        // Assert
        XCTAssertEqual(confirmation.status, .confirmed)
        XCTAssertTrue(repository.isCalled)
        XCTAssertEqual(repository.lastPurchases?.first?.brand, purchases.first?.brand)
    }
    
    // MARK: - Failure Case
    func test_execute_whenFailure_shouldThrowError() async {
        // Arrange
        repository = MockShoppingCartRepository(isSuccessful: false)
        useCase = BuyGiftCardUseCaseImpl(repository: repository)
        
        let purchases = [
            GiftCardPurchase(
                giftCardId: "test-card-1",
                brand: "Test Brand",
                denominations: [
                    Denomination(price: 50.0, currency: "USD", stock: "IN_STOCK")
                ]
            )
        ]
        
        // Act/Assert
        do {
            _ = try await useCase.execute(purchases: purchases)
            XCTFail("Expected error to be thrown")
        } catch let error as NSError {
            XCTAssertEqual(error.localizedDescription, "Failed to process purchase")
            XCTAssertTrue(repository.isCalled)
            XCTAssertEqual(repository.lastPurchases?.first?.brand, purchases.first?.brand)
        }
    }
}
