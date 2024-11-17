//
//  Denomination.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import Foundation

struct Denomination: Codable, Hashable {
    let price: Double
    let currency: String
    let stock: String
}

// MARK: - Mocks
extension Denomination {
    static func mockDenomination(
        price: Double = 10.0,
        currency: String = "USD",
        stock: String = "InStock"
    ) -> Denomination {
        return Denomination(price: price, currency: currency, stock: stock)
    }
}
