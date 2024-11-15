//
//  MockGiftCardShopRepository.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class MockGiftCardShopRepository: GiftCardShopRepository {
    private let isSuccessful: Bool
    var isCalled: Bool
    
    init(isSuccessful: Bool = true, isCalled: Bool = true) {
        self.isSuccessful = isSuccessful
        self.isCalled = isCalled
    }
    
    func fetchGiftCards() async -> Result<[GiftCard], NetworkError> {
        isCalled = true
        if isSuccessful {
            return .success(GiftCard.mockCards)
        } else {
            return .failure(.invalidData)
        }
    }
    
    func fetchGiftCard(id: String) async -> Result<GiftCard, NetworkError> {
        isCalled = true
        if isSuccessful {
            guard let giftCard = GiftCard.mockCards.first(where: { $0.id == id }) else {
                return .failure(.invalidData)
            }
            return .success(GiftCard.kmartCard)
        } else {
            return .failure(.invalidData)
        }
    }
}

