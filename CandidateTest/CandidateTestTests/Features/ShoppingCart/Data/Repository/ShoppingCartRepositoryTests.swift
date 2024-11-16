//
//  ShoppingCartRepositoryTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 15/11/2024.
//

import XCTest

@testable import CandidateTest

final class ShoppingCartRepositoryTests: XCTestCase {
    private var repository: ShoppingCartRepository!
    private var dataSource: MockShoppingCartDataSource!
    
    override func setUp() {
        dataSource = MockShoppingCartDataSource()
        repository = ShoppingCartRepositoryImpl(dataSource: dataSource)
    }
    
    override func tearDown() {
        repository = nil
        dataSource = nil
    }
    
    // MARK: - Success
    func test_buyGiftCards_whenSuccessful_shouldReturnOrderConfirmation() async throws {
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
        let confirmation = try await repository.buyGiftCards(purchases: purchases)
        
        // Assert
        XCTAssertEqual(confirmation.orderId, "mock-order-123")
        XCTAssertEqual(confirmation.status, .confirmed)
        XCTAssertTrue(dataSource.isCalled)
        XCTAssertEqual(dataSource.lastPurchases?.first?.brand, purchases.first?.brand)
    }
    
    // MARK: - Failure
    
    func test_buyGiftCards_whenFailure_shouldThrowError() async {
        // Arrange
        dataSource = MockShoppingCartDataSource(isSuccessful: false)
        repository = ShoppingCartRepositoryImpl(dataSource: dataSource)
        
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
            _ = try await repository.buyGiftCards(purchases: purchases)
            XCTFail("Expected error to be thrown")
        } catch let error as NSError {
            XCTAssertEqual(error.localizedDescription, "Failed to process purchase")
            XCTAssertTrue(dataSource.isCalled)
        }
    }
}
