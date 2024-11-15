//
//  DIContainer+Repository.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

extension DIContainer {
    func registerRepositories() {
        container.register(GiftCardShopRepository.self) { _ in
            GiftCardShopRepositoryImpl(dataSource: self.container.resolve(GiftCardShopDataSource.self)!)
        }
    }
}
