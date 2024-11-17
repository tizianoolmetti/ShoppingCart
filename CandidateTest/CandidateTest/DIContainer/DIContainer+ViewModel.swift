//
//  DIContainer+ViewModel.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

extension DIContainer {
    func registerViewModels() {
        // MARK: - GiftCardShop
        container.register(GiftCardListViewModel.self) { _ in
            GiftCardListViewModel(fetchGiftCardsUseCase: self.container.resolve(FetchGiftCardsUseCase.self)!)
        }
        
        container.register(GiftCardDetailsViewModel.self) { _ in
            GiftCardDetailsViewModel(
                fetchGiftCardDetailsUseCase: self.container.resolve(FetchGiftCardDetailsUseCase.self)!,
                buyGiftCardUseCase: self.container.resolve(BuyGiftCardUseCase.self)!)
        }
        
        // MARK: - ShoppingCart
        container.register(ShoppingCartViewModel.self) { _ in
            ShoppingCartViewModel(
                buyGiftCardUseCase: self.container.resolve(BuyGiftCardUseCase.self)!,
                loadCartUseCase: self.container.resolve(LoadCartUseCase.self)!,
                saveCartUseCase: self.container.resolve(SaveCartUseCase.self)!,
                clearCartUseCase: self.container.resolve(ClearCartUseCase.self)!
            )
        }
    }
}
