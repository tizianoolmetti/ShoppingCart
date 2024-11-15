//
//  GiftCardDetailsViewModel.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class GiftCardDetailsViewModel: ObservableObject {
    // MARK: - Enums
    enum ViewState {
        case idle
        case loading
        case loaded(GiftCard)
        case error(NetworkError)
    }

    // MARK: - Properties
    @Published private(set) var state: ViewState = .idle
    @Published private(set) var selectedDenominations: [Denomination] = []
    @Published var isTermsExpanded = false
    @Published var isInstructionsExpanded = false

    private let fetchGiftCardDetailsUseCase: FetchGiftCardDetailsUseCase

    // MARK: - Initialization
    init(fetchGiftCardDetailsUseCase: FetchGiftCardDetailsUseCase) {
        self.fetchGiftCardDetailsUseCase = fetchGiftCardDetailsUseCase
    }

    // MARK: - Public Methods
    @MainActor
    func fetchGiftCard(with id: String) async {
        state = .loading
        
        let result = await fetchGiftCardDetailsUseCase.execute(id: id)
        switch result {
        case .success(let card):
            state = .loaded(card)
        case .failure(let error):
            state = .error(error)
        }
    }

    func toggleDenomination(_ denomination: Denomination) {
        if selectedDenominations.contains(denomination) {
            selectedDenominations.removeAll(where: { $0 == denomination })
        } else {
            selectedDenominations.append(denomination)
        }
    }

    func toggleTermsExpanded() {
        isTermsExpanded.toggle()
    }

    func toggleInstructionsExpanded() {
        isInstructionsExpanded.toggle()
    }

    func handleBuyNow() {
        // Implement buy now logic
    }

    func handleAddToCart() {
        // Implement add to cart logic
    }

    // MARK: - Computed Properties
    var giftCard: GiftCard? {
        if case .loaded(let card) = state {
            return card
        }
        return nil
    }

    var formattedTotalAmount: String {
        let totalAmount = selectedDenominations.reduce(0) { $0 + $1.price }
        return getFormattedAmount(totalAmount)
    }

    // MARK: - Private Methods
    private func getFormattedAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
}
