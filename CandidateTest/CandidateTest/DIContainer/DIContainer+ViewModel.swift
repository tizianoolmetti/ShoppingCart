//
//  DIContainer+ViewModel.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

extension DIContainer {
    func registerViewModels() {
        container.register(GiftCardListViewModel.self) { _ in
            GiftCardListViewModel(fetchGiftCardsUseCase: self.container.resolve(FetchGiftCardsUseCase.self)!)
        }
        
        container.register(GiftCardDetailsViewModel.self) { _ in
            GiftCardDetailsViewModel(fetchGiftCardDetailsUseCase: self.container.resolve(FetchGiftCardDetailsUseCase.self)!)
        }
    }
}
