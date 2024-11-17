//
//  SaveCartUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 17/11/2024.
//

import Foundation

protocol SaveCartUseCase {
    func execute(items: [GiftCardPurchase]) async throws
}

final class SaveCartUseCaseImpl: SaveCartUseCase {
    private let repository: ShoppingCartRepository
    
    init(repository: ShoppingCartRepository) {
        self.repository = repository
    }
    
    func execute(items: [GiftCardPurchase]) async throws {
        try repository.saveCart(items)
    }
}
