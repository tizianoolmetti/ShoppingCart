//
//  BuyGiftCardUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

protocol BuyGiftCardUseCase {
    func execute(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation
}

final class BuyGiftCardUseCaseImpl: BuyGiftCardUseCase {
    private let repository: ShoppingCartRepository
    
    init(repository: ShoppingCartRepository) {
        self.repository = repository
    }
    
    func execute(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation {
        try await repository.buyGiftCards(purchases: purchases)
    }
}
