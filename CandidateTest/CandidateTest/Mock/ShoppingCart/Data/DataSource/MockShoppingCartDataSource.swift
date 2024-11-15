//
//  MockShoppingCartDataSource.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class MockShoppingCartDataSource: ShoppingCartDataSource {
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
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(0.1 * 1_000_000_000)) // 0.1 second delay for tests
        
        guard isSuccessful else {
            throw ShoppingCartError.purchaseFailed
        }
        
        return OrderConfirmation(
            orderId: "mock-order-123",
            status: .confirmed,
            timestamp: Date(),
            items: purchases.map { purchase in
                OrderConfirmation.PurchasedItem(
                    giftCardId: purchase.giftCardId,
                    brand: "Mock Brand",
                    denominations: purchase.denominations,
                    subtotal: purchase.totalAmount
                )
            },
            totalAmount: purchases.reduce(0) { $0 + $1.totalAmount }
        )
    }
}

enum ShoppingCartError: LocalizedError {
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .purchaseFailed:
            return "Failed to process purchase"
        }
    }
}
