//
//  MockShoppingCartRepository.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class MockShoppingCartRepository: ShoppingCartRepository {
    // MARK: Properties
    private let isSuccessful: Bool
    private(set) var isCalled: Bool
    private(set) var lastLoadCalled = false
    private(set) var lastSaveCalled = false
    private(set) var lastClearCalled = false
    private(set) var lastPurchases: [GiftCardPurchase]?
    private(set) var lastSavedItems: [GiftCardPurchase]?
    
    // MARK: Initializer
    init(isSuccessful: Bool = true, isCalled: Bool = false) {
        self.isSuccessful = isSuccessful
        self.isCalled = isCalled
    }
    
    // MARK: Shopping Cart Repository Methods
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
                    giftCardId: purchase.brand,
                    brand: "Test Brand",
                    denominations: purchase.denominations,
                    subtotal: purchase.denominations.reduce(0) { $0 + $1.price }
                )
            },
            totalAmount: purchases.reduce(0) { $0 + $1.totalAmount }
        )
    }
    
    
    func loadCart() throws -> [GiftCardPurchase] {
        lastLoadCalled = true
        isCalled = true
        
        guard isSuccessful else {
            throw ShoppingCartError.loadFailed
        }
        
        return [
            GiftCardPurchase(
                giftCardId: "mock-id-1",
                brand: "Mock Brand 1",
                denominations: [
                    Denomination(price: 50.0, currency: "AUD", stock: "IN_STOCK")
                ]
            ),
            GiftCardPurchase(
                giftCardId: "mock-id-2",
                brand: "Mock Brand 2",
                denominations: [
                    Denomination(price: 100.0, currency: "AUD", stock: "IN_STOCK")
                ]
            )
        ]
    }
    
    func saveCart(_ items: [GiftCardPurchase]) throws {
        lastSaveCalled = true
        isCalled = true
        lastSavedItems = items
        
        guard isSuccessful else {
            throw ShoppingCartError.saveFailed
        }
    }
    
    func clearCart() throws {
        lastClearCalled = true
        isCalled = true
        
        guard isSuccessful else {
            throw ShoppingCartError.clearFailed
        }
    }
}

// MARK: - Helper Extensions for Testing
extension MockShoppingCartRepository {
    var wasLoadCalled: Bool {
        lastLoadCalled
    }
    
    var wasSaveCalled: Bool {
        lastSaveCalled
    }
    
    var wasClearCalled: Bool {
        lastClearCalled
    }
    
    var lastSavedItemsCount: Int {
        lastSavedItems?.count ?? 0
    }
    
    var lastPurchasesCount: Int {
        lastPurchases?.count ?? 0
    }
}
