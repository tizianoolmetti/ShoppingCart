//
//  MockShoppingCartRepository.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class MockShoppingCartRepository: ShoppingCartRepository {
    private let isSuccessful: Bool
    private(set) var isCalled: Bool
    private(set) var lastPurchases: [GiftCardPurchase]?
    
    init(isSuccessful: Bool = true, isCalled: Bool = false) {
        self.isSuccessful = isSuccessful
        self.isCalled = isCalled
        self.lastPurchases = nil
    }
    
    func buyGiftCards(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation {
        isCalled = true
        lastPurchases = purchases
        
        // Simulate minimal delay for testing
        try await Task.sleep(nanoseconds: UInt64(0.05 * 1_000_000_000))
        
        guard isSuccessful else {
            throw ShoppingCartError.purchaseFailed
        }
        
        return OrderConfirmation(
            orderId: "mock-repo-order-\(UUID().uuidString)",
            status: .confirmed,
            timestamp: Date(),
            items: purchases.map { purchase in
                OrderConfirmation.PurchasedItem(
                    giftCardId: purchase.giftCardId,
                    brand: "Test Brand",
                    denominations: purchase.denominations,
                    subtotal: purchase.denominations.reduce(0) { $0 + $1.price }
                )
            },
            totalAmount: purchases.reduce(0) { $0 + $1.totalAmount }
        )
    }
}
