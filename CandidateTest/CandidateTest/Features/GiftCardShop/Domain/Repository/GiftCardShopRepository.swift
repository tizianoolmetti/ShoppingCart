//
//  GiftCardShopRepository.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import Foundation

protocol GiftCardShopRepository {
    func fetchGiftCards() async -> Result<[GiftCard], NetworkError>
    func fetchGiftCard(id: String) async -> Result<GiftCard, NetworkError>
}

