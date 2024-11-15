//
//  GiftCardPurchase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

struct GiftCardPurchase {
    let giftCardId: String
    let denominations: [Denomination]
    
    var totalAmount: Double {
        denominations.reduce(0) { $0 + $1.price }
    }
}
