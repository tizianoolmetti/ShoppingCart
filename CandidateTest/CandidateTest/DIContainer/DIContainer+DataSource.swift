//
//  DIContainer+DataSource.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

extension DIContainer {
    func registerDataSources() {
        container.register(GiftCardShopDataSource.self) { _ in
            GiftCardShopDataSourceImpl(service: self.container.resolve(NetworkService.self)!)
        }
    }
}
