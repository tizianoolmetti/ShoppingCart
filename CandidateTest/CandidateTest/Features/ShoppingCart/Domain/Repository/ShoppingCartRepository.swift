//
//  ShoppingCartRepository.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

protocol ShoppingCartRepository {
    func buyGiftCards(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation
    func loadCart() throws -> [GiftCardPurchase]
    func saveCart(_ items: [GiftCardPurchase]) throws
    func clearCart() throws
}
