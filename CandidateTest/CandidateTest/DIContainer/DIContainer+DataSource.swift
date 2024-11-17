//
//  DIContainer+DataSource.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

extension DIContainer {
    func registerDataSources() {
        // MARK: - GiftCardShop
        container.register(GiftCardShopDataSource.self) { _ in
            GiftCardShopDataSourceImpl(service: self.container.resolve(NetworkService.self)!)
        }
        
        // MARK: - ShoppingCart
        container.register(ShoppingCartDataSource.self) { _ in
            ShoppingCartDataSourceImpl(cartCacheManager: self.container.resolve(CartCacheManager.self)!)
        }
    }
}
