//
//  GiftCardPurchase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

struct GiftCardPurchase {
    let id = UUID()
    let giftCardId: String
    let brand: String
    let denominations: [Denomination]
    
    var totalAmount: Double {
        denominations.reduce(0) { $0 + $1.price }
    }
}

extension GiftCardPurchase {
    static let mockPurchases: [GiftCardPurchase] = [
        GiftCardPurchase(
            giftCardId: "1",
            brand: "Kmart",
            denominations: [
                Denomination(price: 50.0, currency: "USD", stock: "IN_STOCK"),
                Denomination(price: 100.0, currency: "USD", stock: "IN_STOCK")
            ]
        ),
        GiftCardPurchase(
            giftCardId: "2",
            brand: "Apple",
            denominations: [
                Denomination(price: 25.0, currency: "USD", stock: "IN_STOCK")
            ]
        ),
        GiftCardPurchase(
            giftCardId: "3",
            brand: "Google",
            denominations: [
                Denomination(price: 75.0, currency: "USD", stock: "IN_STOCK"),
                Denomination(price: 150.0, currency: "USD", stock: "IN_STOCK"),
                Denomination(price: 200.0, currency: "USD", stock: "IN_STOCK")
            ]
        )
    ]
    
    static let mockSinglePurchase = GiftCardPurchase(
        giftCardId: "4",
        brand: "Amazon",
        denominations: [
            Denomination(price: 50.0, currency: "USD", stock: "IN_STOCK")
        ]
    )
}
