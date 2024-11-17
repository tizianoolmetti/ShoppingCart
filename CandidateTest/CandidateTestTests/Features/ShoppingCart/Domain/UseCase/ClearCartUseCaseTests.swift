//
//  ClearCartUseCaseTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 17/11/2024.
//

import XCTest

@testable import CandidateTest

final class ClearCartUseCaseTests: XCTestCase {
    private var useCase: ClearCartUseCase!
    private var repository: MockShoppingCartRepository!
    
    override func setUp() {
        repository = MockShoppingCartRepository()
        useCase = ClearCartUseCaseImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
    }
    
    func test_execute_whenSuccessful_shouldClearCart() {
        // Arrange
        let expectation = expectation(description: "Should clear cart")
        
        // Act
        Task {
            do {
                try await useCase.execute()
                expectation.fulfill()
            } catch {
                XCTFail("Should not throw error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        // Assert
        XCTAssertTrue(repository.isCalled, "Should call clearCart() in repository")
        XCTAssertTrue(repository.wasClearCalled, "Should mark clear as called")
    }
    
    func test_execute_whenFailure_shouldThrowError() {
        // Arrange
        repository = MockShoppingCartRepository(isSuccessful: false)
        useCase = ClearCartUseCaseImpl(repository: repository)
        let expectation = expectation(description: "Should throw error")
        
        // Act
        Task {
            do {
                try await useCase.execute()
                XCTFail("Should throw an error")
            } catch {
                XCTAssertTrue(repository.isCalled, "Should call clearCart() in repository")
                XCTAssertEqual(error as? ShoppingCartError, .clearFailed)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
