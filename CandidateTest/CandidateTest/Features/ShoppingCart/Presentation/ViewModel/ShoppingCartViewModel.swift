//
//  CartViewModel.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import SwiftUI

// MARK: - Shopping Cart View Model
final class ShoppingCartViewModel: ObservableObject {
    // MARK: Published
    @Published private(set) var items: [GiftCardPurchase] = []
    @Published private(set) var totalAmount: Double = 0
    @Published var purchaseState: PurchaseState = .idle
    
    // MARK: Private
    private let buyGiftCardUseCase: BuyGiftCardUseCase
    
    // MARK: Initialization
    init(buyGiftCardUseCase: BuyGiftCardUseCase) {
        self.buyGiftCardUseCase = buyGiftCardUseCase
    }
}

// MARK: - Computed Properties
extension ShoppingCartViewModel {
    var itemCount: Int {
        items.count
    }
    
    var formattedTotalAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: totalAmount)) ?? "0"
    }
    
    var hasItems: Bool {
        !items.isEmpty
    }
}

// MARK: - Cart Management
extension ShoppingCartViewModel {
    func add(giftCard: GiftCard, denominations: [Denomination]) {
        let purchase = GiftCardPurchase(
            giftCardId: giftCard.id,
            brand: giftCard.brand,
            denominations: denominations
        )
        
        if let index = items.firstIndex(where: { $0.brand == giftCard.id }) {
            items[index] = purchase
        } else {
            items.append(purchase)
        }
        
        updateTotalAmount()
    }
    
    func remove(giftCardId: String) {
        withAnimation {
            items.removeAll { $0.brand == giftCardId }
            updateTotalAmount()
        }
    }
    
    func clear() {
        withAnimation {
            items.removeAll()
            totalAmount = 0
        }
    }
    
    func contains(giftCardId: String) -> Bool {
        items.contains { $0.brand == giftCardId }
    }
}

// MARK: - Private Helpers
private extension ShoppingCartViewModel {
    func updateTotalAmount() {
        totalAmount = items.reduce(0) { total, purchase in
            total + purchase.denominations.reduce(0) { $0 + $1.price }
        }
    }
}

// MARK: - Checkout
extension ShoppingCartViewModel {
    @MainActor
    func checkout() async {
        guard !items.isEmpty else { return }
        
        purchaseState = .purchasing
        
        do {
            let confirmation = try await buyGiftCardUseCase.execute(purchases: items)
            purchaseState = .completed(confirmation)
            items = []
            totalAmount = 0
        } catch {
            purchaseState = .error(error)
        }
    }
}
