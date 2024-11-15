//
//  CartRepository.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class ShoppingCartRepositoryImpl: ShoppingCartRepository {
    private let dataSource: ShoppingCartDataSource
    
    init(dataSource: ShoppingCartDataSource) {
        self.dataSource = dataSource
    }
    
    func buyGiftCards(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation {
        try await dataSource.buyGiftCards(purchases: purchases)
    }
}
