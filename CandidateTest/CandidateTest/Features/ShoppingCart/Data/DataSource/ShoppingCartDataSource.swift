//
//  ShoppingCartDataSource.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation
protocol ShoppingCartDataSource {
    func buyGiftCards(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation
}

final class ShoppingCartDataSourceImpl: ShoppingCartDataSource {
    // Mock data store for gift card details
    private var giftCardDetails: [String: GiftCard] = [:]
    
    func buyGiftCards(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Simulate potential failure (10% chance)
        let shouldFail = Double.random(in: 0...1) < 0.1
        if shouldFail {
            throw NSError(domain: "GiftCardError", code: 500, userInfo: [
                NSLocalizedDescriptionKey: "Failed to process purchase. Please try again."
            ])
        }
        
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
                giftCardId: purchase.giftCardId,
                brand: "Brand for \(purchase.giftCardId)", // In real implementation, fetch from giftCardDetails
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
}