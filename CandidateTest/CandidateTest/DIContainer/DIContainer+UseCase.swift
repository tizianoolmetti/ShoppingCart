//
//  DIContainer+UseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

extension DIContainer {
    func registerUseCases() {
        
        // MARK: - GiftCardShop
        container.register(FetchGiftCardsUseCase.self) { _ in
            FetchGiftCardsUseCaseImpl(repository: self.container.resolve(GiftCardShopRepository.self)!)
        }
        
        container.register(FetchGiftCardDetailsUseCase.self) { _ in
            FetchGiftCardDetailsUseCaseImpl(repository: self.container.resolve(GiftCardShopRepository.self)!)
        }
        
        // MARK: - ShoppingCart
        container.register(BuyGiftCardUseCase.self) { _ in
            BuyGiftCardUseCaseImpl(repository: self.container.resolve(ShoppingCartRepository.self)!)
        }
        
        container.register(LoadCartUseCase.self) { _ in
            LoadCartUseCaseImpl(repository: self.container.resolve(ShoppingCartRepository.self)!)
        }
        
        container.register(SaveCartUseCase.self) { _ in
            SaveCartUseCaseImpl(repository: self.container.resolve(ShoppingCartRepository.self)!)
        }
        
        container.register(ClearCartUseCase.self) { _ in
            ClearCartUseCaseImpl(repository: self.container.resolve(ShoppingCartRepository.self)!)
        }
    }
}

