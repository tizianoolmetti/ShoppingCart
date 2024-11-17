//
//  CartRepository.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class ShoppingCartRepositoryImpl: ShoppingCartRepository {
    // MARK: Properties
    private let dataSource: ShoppingCartDataSource
    
    // MARK: Initializers
    init(dataSource: ShoppingCartDataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: Methods
    func buyGiftCards(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation {
        try await dataSource.buyGiftCards(purchases: purchases)
    }
    
    func loadCart() throws -> [GiftCardPurchase] {
        try dataSource.loadCart()
    }
    
    func saveCart(_ items: [GiftCardPurchase]) throws {
        try dataSource.saveCart(items)
    }
    
    func clearCart() throws {
        try dataSource.clearCart()
    }
}
