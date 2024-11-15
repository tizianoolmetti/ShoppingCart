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
