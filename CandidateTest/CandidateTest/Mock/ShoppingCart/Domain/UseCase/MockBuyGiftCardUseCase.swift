//
//  MockBuyGiftCardUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class MockBuyGiftCardUseCase: BuyGiftCardUseCase {
    
    // MARK: - Properties
    private let repository: ShoppingCartRepository
    private let isSuccessful: Bool
    private(set) var isCalled: Bool
    private(set) var lastPurchases: [GiftCardPurchase]?
    private(set) var executeCount: Int = 0
    
    // MARK: - Initializers
    init(
        repository: ShoppingCartRepository = MockShoppingCartRepository(),
        isSuccessful: Bool = true,
        isCalled: Bool = false
    ) {
        self.repository = repository
        self.isSuccessful = isSuccessful
        self.isCalled = isCalled
    }
    
    // MARK: - Methods
    func execute(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation {
        isCalled = true
        executeCount += 1
        lastPurchases = purchases
        
        // Simulate minimal processing time
        try await Task.sleep(nanoseconds: UInt64(0.05 * 1_000_000_000))
        
        guard isSuccessful else {
            throw ShoppingCartError.purchaseFailed
        }
        
        let confirmation = OrderConfirmation(
            orderId: "mock-usecase-\(UUID().uuidString)",
            status: .confirmed,
            timestamp: Date(),
            items: purchases.map { purchase in
                OrderConfirmation.PurchasedItem(
                    giftCardId: purchase.brand,
                    brand: "Test Brand",
                    denominations: purchase.denominations,
                    subtotal: purchase.totalAmount
                )
            },
            totalAmount: purchases.reduce(0) { $0 + $1.totalAmount }
        )
        
        return confirmation
    }
}
