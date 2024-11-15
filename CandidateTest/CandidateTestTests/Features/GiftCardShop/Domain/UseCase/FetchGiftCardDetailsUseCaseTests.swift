//
//  FetchGiftCardDetailsUseCaseTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 15/11/2024.
//

import XCTest

@testable import CandidateTest

final class FetchGiftCardDetailsUseCaseTests: XCTestCase {
    private var useCase: FetchGiftCardDetailsUseCase!
    private var repository: MockGiftCardShopRepository!
    
    private let test_id = "0f3f7b67-6f75-4f0b-9ed9-b746c2eb0bd6"

    override func setUp() {
        repository = MockGiftCardShopRepository()
        useCase = FetchGiftCardDetailsUseCaseImpl(repository: repository)
    }

    override func tearDown() {
        repository = nil
        useCase = nil
    }

    // MARK: - Successful Case

    func test_execute_whenSuccessful_shouldReturnGiftCard() async throws {
        // Arrange and Act
        let result = await useCase.execute(id: test_id)

        // Assert
        XCTAssertTrue(repository.isCalled, "Should call fetchGiftCard() in repository")
        switch result {
        case .success(let giftCard):
            XCTAssertEqual(giftCard.id, test_id, "Should return the correct gift card")
        case .failure(let error):
            XCTFail("Should not return an error: \(error)")
        }
    }

    // MARK: - Failure Case

    func test_execute_whenFailure_shouldReturnError() async throws {
        // Arrange
        repository = MockGiftCardShopRepository(isSuccessful: false)
        useCase = FetchGiftCardDetailsUseCaseImpl(repository: repository)


        // Act
        let result = await useCase.execute(id: test_id)

        // Assert
        XCTAssertTrue(repository.isCalled, "Should call fetchGiftCard() in repository")
        switch result {
        case .success(let giftCard):
            XCTAssertNil(giftCard, "Should not return a gift card")
        case .failure(let error):
            XCTAssertNotNil(error, "Should return an error")
        }
    }
}
