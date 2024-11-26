//
//  MockFetchGiftCardDetailsUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class MockFetchGiftCardDetailsUseCase: FetchGiftCardDetailsUseCase {
    
    // MARK: Properties
    private let repository: GiftCardShopRepository
    private let isSuccessful: Bool
    private(set) var isCalled: Bool

    // MARK: Initializers
    init(
        repository: GiftCardShopRepository = MockGiftCardShopRepository(),
        isSuccessful: Bool = true,
        isCalled: Bool = true
    ) {
        self.repository = repository
        self.isSuccessful = isSuccessful
        self.isCalled = isCalled
    }

    // MARK: Methods
    func execute(id: String) async -> Result<GiftCard, NetworkError> {
        isCalled = true
        if isSuccessful {
            return await repository.fetchGiftCard(id: id)
        } else {
            return .failure(.invalidData)
        }
    }
}
