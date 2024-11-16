//
//  OrderConfirmation.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

struct OrderConfirmation {
    let orderId: String
    let status: OrderStatus
    let timestamp: Date
    let items: [PurchasedItem]
    let totalAmount: Double
    
    struct PurchasedItem {
        let giftCardId: String
        let brand: String
        let denominations: [Denomination]
        let subtotal: Double
    }
}

// MARK: - Mock
extension OrderConfirmation {
    static func mockOrderConfirmation() -> OrderConfirmation {
        let purchasedItems = [
            OrderConfirmation.PurchasedItem(
                giftCardId: "1",
                brand: "Kmart",
                denominations: [
                    Denomination(price: 50.0, currency: "USD", stock: "IN_STOCK")
                ],
                subtotal: 50.0
            ),
            OrderConfirmation.PurchasedItem(
                giftCardId: "2",
                brand: "Target",
                denominations: [
                    Denomination(price: 75.0, currency: "USD", stock: "IN_STOCK")
                ],
                subtotal: 75.0
            )
        ]
        
        return OrderConfirmation(
            orderId: "ORDER-123456",
            status: .confirmed,
            timestamp: Date(),
            items: purchasedItems,
            totalAmount: 125.0
        )
    }
}
