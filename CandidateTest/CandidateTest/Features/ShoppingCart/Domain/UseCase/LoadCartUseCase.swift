//
//  LoadCartUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 17/11/2024.
//

import Foundation

protocol LoadCartUseCase {
    func execute() async throws -> [GiftCardPurchase]
}

final class LoadCartUseCaseImpl: LoadCartUseCase {
    private let repository: ShoppingCartRepository
    
    init(repository: ShoppingCartRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [GiftCardPurchase] {
        try repository.loadCart()
    }
}
