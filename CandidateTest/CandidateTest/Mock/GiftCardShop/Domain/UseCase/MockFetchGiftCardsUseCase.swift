//
//  MockFetchGiftCardsUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class MockFetchGiftCardsUseCase: FetchGiftCardsUseCase {
    private let repository: GiftCardShopRepository
    private let isSuccessful: Bool
    private(set) var isCalled: Bool

    init(
        repository: GiftCardShopRepository = MockGiftCardShopRepository(),
        isSuccessful: Bool = true,
        isCalled: Bool = true
    ) {
        self.repository = repository
        self.isSuccessful = isSuccessful
        self.isCalled = isCalled
    }

    func execute() async -> Result<[GiftCard], NetworkError> {
        isCalled = true
        if isSuccessful {
            return await repository.fetchGiftCards()
        } else {
            return .failure(.invalidData)
        }
    }
}