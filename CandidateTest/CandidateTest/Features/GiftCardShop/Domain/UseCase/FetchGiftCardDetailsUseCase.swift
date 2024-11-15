//
//  FetchGiftCardDetailsUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

protocol FetchGiftCardDetailsUseCase {
    func execute(id: String) async -> Result<GiftCard, NetworkError>
}

final class FetchGiftCardDetailsUseCaseImpl: FetchGiftCardDetailsUseCase {
    private let repository: GiftCardShopRepository
    
    init(repository: GiftCardShopRepository) {
        self.repository = repository
    }
    
    func execute(id: String) async -> Result<GiftCard, NetworkError> {
        return await repository.fetchGiftCard(id: id)
    }
}
