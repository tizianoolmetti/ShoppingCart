//
//  GiftCardShopRepositoryImpl.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import Foundation

final class GiftCardShopRepositoryImpl: GiftCardShopRepository {
    private let dataSource: GiftCardShopDataSource
    
    init(dataSource: GiftCardShopDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchGiftCards() async -> Result<[GiftCard], NetworkError> {
        return await dataSource.fetchGiftCards()
    }
    
    func fetchGiftCard(id: String) async -> Result<GiftCard, NetworkError> {
        return await dataSource.fetchGiftCard(id: id)
    }
}
