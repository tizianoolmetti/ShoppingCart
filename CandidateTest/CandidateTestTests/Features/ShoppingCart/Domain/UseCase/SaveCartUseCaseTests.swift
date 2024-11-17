//
//  SaveCartUseCaseTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 17/11/2024.
//

import XCTest

@testable import CandidateTest

final class SaveCartUseCaseTests: XCTestCase {
    private var useCase: SaveCartUseCase!
    private var repository: MockShoppingCartRepository!
    
    override func setUp() {
        repository = MockShoppingCartRepository()
        useCase = SaveCartUseCaseImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
    }
    
    func test_execute_whenSuccessful_shouldSaveItems() {
        // Arrange
        let expectation = expectation(description: "Should save cart items")
        let itemsToSave = GiftCardPurchase.mockPurchases
        
        // Act
        Task {
            do {
                try await useCase.execute(items: itemsToSave)
                expectation.fulfill()
            } catch {
                XCTFail("Should not throw error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertTrue(repository.isCalled, "Should call saveCart() in repository")
        XCTAssertEqual(repository.lastSavedItems?.count, itemsToSave.count, "Should save correct number of items")
        XCTAssertEqual(repository.lastSavedItems?.first?.giftCardId, itemsToSave.first?.giftCardId, "Should save correct items")
    }
    
    func test_execute_whenFailure_shouldThrowError() {
        // Arrange
        repository = MockShoppingCartRepository(isSuccessful: false)
        useCase = SaveCartUseCaseImpl(repository: repository)
        let expectation = expectation(description: "Should throw error")
        let itemsToSave = GiftCardPurchase.mockPurchases
        
        // Act
        Task {
            do {
                try await useCase.execute(items: itemsToSave)
                XCTFail("Should throw an error")
            } catch {
                XCTAssertTrue(repository.isCalled, "Should call saveCart() in repository")
                XCTAssertEqual(error as? ShoppingCartError, .saveFailed)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
