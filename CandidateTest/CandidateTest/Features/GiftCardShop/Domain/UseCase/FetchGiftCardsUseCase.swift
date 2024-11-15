//
//  FetchGiftCardsUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import Foundation

protocol FetchGiftCardsUseCase {
    func execute() async -> Result<[GiftCard], NetworkError>
}

final class FetchGiftCardsUseCaseImpl: FetchGiftCardsUseCase {
    private let repository: GiftCardShopRepository
    
    init(repository: GiftCardShopRepository) {
        self.repository = repository
    }
    
    func execute() async -> Result<[GiftCard], NetworkError> {
        return await repository.fetchGiftCards()
    }
}
