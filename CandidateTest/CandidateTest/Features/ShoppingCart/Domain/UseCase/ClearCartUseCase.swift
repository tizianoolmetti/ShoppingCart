//
//  ClearCartUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 17/11/2024.
//

import Foundation

protocol ClearCartUseCase {
    func execute() async throws
}

final class ClearCartUseCaseImpl: ClearCartUseCase {
    private let repository: ShoppingCartRepository
    
    init(repository: ShoppingCartRepository) {
        self.repository = repository
    }
    
    func execute() async throws {
        try repository.clearCart()
    }
}
