//
//  ShoppingCartDataSource.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation
protocol ShoppingCartDataSource {
    func buyGiftCards(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation
    func loadCart() throws -> [GiftCardPurchase]
    func saveCart(_ items: [GiftCardPurchase]) throws
    func clearCart() throws
}

final class ShoppingCartDataSourceImpl: ShoppingCartDataSource {
    // MARK: Properties
    private var giftCardDetails: [String: GiftCard] = [:]
    private let cartCacheManager: CartCacheManager
    
    // MARK: Initializers
    init(cartCacheManager: CartCacheManager) {
        self.cartCacheManager = cartCacheManager
    }
    
    // MARK: Methods
    func buyGiftCards(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Validate purchase amounts
        for purchase in purchases {
            guard !purchase.denominations.isEmpty else {
                throw NSError(domain: "GiftCardError", code: 400, userInfo: [
                    NSLocalizedDescriptionKey: "Each gift card must have at least one denomination selected."
                ])
            }
        }
        
        // Create purchased items with mock brand names
        let purchasedItems = purchases.map { purchase in
            OrderConfirmation.PurchasedItem(
                giftCardId: purchase.brand,
                brand: "Brand for \(purchase.brand)",
                denominations: purchase.denominations,
                subtotal: purchase.totalAmount
            )
        }
        
        // Calculate total amount
        let totalAmount = purchases.reduce(0) { $0 + $1.totalAmount }
        
        // Success case
        return OrderConfirmation(
            orderId: UUID().uuidString,
            status: .confirmed,
            timestamp: Date(),
            items: purchasedItems,
            totalAmount: totalAmount
        )
    }
    
    func loadCart() throws -> [GiftCardPurchase] {
        try cartCacheManager.loadCart()
    }
    
    func saveCart(_ items: [GiftCardPurchase]) throws {
        try cartCacheManager.saveCart(items)
    }
    
    func clearCart() throws {
        try cartCacheManager.clearCart()
    }
}
