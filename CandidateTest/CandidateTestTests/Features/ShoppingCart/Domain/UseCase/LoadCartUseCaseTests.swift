//
//  LoadCartUseCaseTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 17/11/2024.
//

import XCTest

@testable import CandidateTest

final class LoadCartUseCaseTests: XCTestCase {
    private var useCase: LoadCartUseCase!
    private var repository: MockShoppingCartRepository!
    
    override func setUp() {
        repository = MockShoppingCartRepository()
        useCase = LoadCartUseCaseImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
    }
    
    func test_execute_whenSuccessful_shouldReturnCartItems() {
        // Arrange
        let expectation = expectation(description: "Should load cart items")
        var resultItems: [GiftCardPurchase]?
        
        // Act
        Task {
            do {
                resultItems = try await useCase.execute()
                expectation.fulfill()
            } catch {
                XCTFail("Should not throw error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertTrue(repository.isCalled, "Should call loadCart() in repository")
        XCTAssertNotNil(resultItems, "Should return items")
        XCTAssertFalse(resultItems?.isEmpty ?? true, "Should not be empty")
        XCTAssertEqual(resultItems?.first?.giftCardId, "mock-id-1", "Should return correct items")
    }
    
    func test_execute_whenFailure_shouldThrowError() {
        // Arrange
        repository = MockShoppingCartRepository(isSuccessful: false)
        useCase = LoadCartUseCaseImpl(repository: repository)
        let expectation = expectation(description: "Should throw error")
        
        // Act
        Task {
            do {
                _ = try await useCase.execute()
                XCTFail("Should throw an error")
            } catch {
                XCTAssertTrue(repository.isCalled, "Should call loadCart() in repository")
                XCTAssertEqual(error as? ShoppingCartError, .loadFailed)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
