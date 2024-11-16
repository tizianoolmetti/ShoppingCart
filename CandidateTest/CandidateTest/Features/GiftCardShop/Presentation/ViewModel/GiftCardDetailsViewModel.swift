//
//  GiftCardDetailsViewModel.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class GiftCardDetailsViewModel: ObservableObject {
    // MARK: Published
    @Published private(set) var state: CartViewState = .idle
    @Published var purchaseState: PurchaseState = .idle
    @Published var selectedDenominations: [Denomination] = []
    @Published var isTermsExpanded = false
    @Published var isInstructionsExpanded = false
    
    // MARK: Private
    private let fetchGiftCardDetailsUseCase: FetchGiftCardDetailsUseCase
    private let buyGiftCardUseCase: BuyGiftCardUseCase
    
    // MARK: Initialization
    init(
        fetchGiftCardDetailsUseCase: FetchGiftCardDetailsUseCase,
        buyGiftCardUseCase: BuyGiftCardUseCase
    ){
        self.fetchGiftCardDetailsUseCase = fetchGiftCardDetailsUseCase
        self.buyGiftCardUseCase = buyGiftCardUseCase
    }
    
    // MARK: Fetch Gift Card
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
    
    // MARK: Actions
    func toggleDenomination(_ denomination: Denomination) {
        if selectedDenominations.contains(denomination) {
            selectedDenominations.removeAll(where: { $0 == denomination })
        } else {
            selectedDenominations.append(denomination)
        }
    }
    
    // MARK: Buy Gift Card
    @MainActor
    func handleBuyNow(id: String, brand: String) async {
        guard !selectedDenominations.isEmpty else { return }
        
        purchaseState = .purchasing
        
        let purchase = GiftCardPurchase(
            giftCardId: id,
            brand: brand,
            denominations: selectedDenominations
        )
        
        do {
            let confirmation = try await buyGiftCardUseCase.execute(purchases: [purchase])
            purchaseState = .completed(confirmation)
            selectedDenominations = []
        } catch {
            purchaseState = .error(error)
        }
    }
    
    // MARK: Computed Properties
    var giftCard: GiftCard? {
        if case .loaded(let card) = state {
            return card
        }
        return nil
    }
    
    var isLoaded: Bool {
        if case .loaded = state {
            return true
        }
        return false
    }
    
    var formattedTotalAmount: String {
        let totalAmount = selectedDenominations.reduce(0) { $0 + $1.price }
        return getFormattedAmount(totalAmount)
    }
    
    // MARK: Private Methods
    private func getFormattedAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
}
