//
//  GiftCardShopDataSource.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import Foundation

protocol GiftCardShopDataSource {
    func fetchGiftCards() async -> Result<[GiftCard], NetworkError>
    func fetchGiftCard(id: String) async -> Result<GiftCard, NetworkError>
}

final class GiftCardShopDataSourceImpl: GiftCardShopDataSource {
    private let service: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    func fetchGiftCards() async -> Result<[GiftCard], NetworkError> {
        do {
            let giftCards: [GiftCard] = try await service.request(GiftCardsEndpoint.list)
            return .success(giftCards)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.networkError(error))
        }
    }
    
    func fetchGiftCard(id: String) async -> Result<GiftCard, NetworkError> {
            do {
                let card: GiftCard = try await service.request(GiftCardsEndpoint.detail(id: id))
                return .success(card)
            } catch let error as NetworkError {
                return .failure(error)
            } catch {
                return .failure(.networkError(error))
            }
        }
}
