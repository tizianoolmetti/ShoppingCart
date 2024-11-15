//
//  GiftCardDetailsViewModelTests.swift
//  CandidateTestTests
//
//  Created by Tom Olmetti on 15/11/2024.
//

import XCTest

@testable import CandidateTest

final class GiftCardDetailsViewModelTests: XCTestCase {
    private var viewModel: GiftCardDetailsViewModel!
    private var fetchGiftCardDetailsUseCase: MockFetchGiftCardDetailsUseCase!
    
    private let test_id = "0f3f7b67-6f75-4f0b-9ed9-b746c2eb0bd6"

    override func setUp() {
        fetchGiftCardDetailsUseCase = MockFetchGiftCardDetailsUseCase()
        viewModel = GiftCardDetailsViewModel(fetchGiftCardDetailsUseCase: fetchGiftCardDetailsUseCase)
    }

    override func tearDown() {
        viewModel = nil
        fetchGiftCardDetailsUseCase = nil
    }

    func test_fetchGiftCard_whenSuccessful_shouldUpdateState() async {
        // Arrange and Act
        await viewModel.fetchGiftCard(with: test_id)

        // Assert
        XCTAssertTrue(fetchGiftCardDetailsUseCase.isCalled, "Should call execute() on the use case")
        if case .loaded(let card) = viewModel.state {
            XCTAssertEqual(card.id, GiftCard.kmartCard.id, "Should update state with fetched gift card")
        } else {
            XCTFail("Expected state to be .loaded")
        }
    }

    func test_fetchGiftCard_whenFailure_shouldUpdateStateToError() async {
        // Arrange
        let mockError = NetworkError.invalidData
        fetchGiftCardDetailsUseCase = MockFetchGiftCardDetailsUseCase(isSuccessful: false, isCalled: false)
        viewModel = GiftCardDetailsViewModel(fetchGiftCardDetailsUseCase: fetchGiftCardDetailsUseCase)

        // Act
        await viewModel.fetchGiftCard(with: test_id)

        // Assert
        XCTAssertTrue(fetchGiftCardDetailsUseCase.isCalled, "Should call execute() on the use case")
        if case .error(let error) = viewModel.state {
            XCTAssertEqual(error.localizedDescription, mockError.localizedDescription, "Should update state with the expected error")
        } else {
            XCTFail("Expected state to be .error")
        }
    }
    
    func test_toggleDenomination_shouldAddDenomination() {
        // Arrange
        let denomination = Denomination.mockDenomination()

        // Act
        viewModel.toggleDenomination(denomination)

        // Assert
        XCTAssertTrue(viewModel.selectedDenominations.contains(denomination), "Denomination should be added")
    }

    func test_toggleDenomination_shouldRemoveDenomination() {
        // Arrange
        let denomination = Denomination.mockDenomination()
        viewModel.toggleDenomination(denomination)  // Add it first

        // Act
        viewModel.toggleDenomination(denomination)  // Toggle to remove it

        // Assert
        XCTAssertFalse(viewModel.selectedDenominations.contains(denomination), "Denomination should be removed")
    }

    func test_formattedTotalAmount_withMultipleDenominations() {
        // Arrange
        let denomination1 = Denomination.mockDenomination(price: 20.0)
        let denomination2 = Denomination.mockDenomination(price: 30.0)
        viewModel.toggleDenomination(denomination1)
        viewModel.toggleDenomination(denomination2)

        // Act
        let formattedAmount = viewModel.formattedTotalAmount

        // Assert
        XCTAssertEqual(formattedAmount, "$50.00", "Formatted total amount should be correct") // Update based on your locale
    }
}
