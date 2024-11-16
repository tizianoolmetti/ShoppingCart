//
//  GiftCardListViewModel.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import Foundation

// MARK: - ViewModel
final class GiftCardListViewModel: ObservableObject {
    // MARK: Published
    @Published var state: ViewState = .idle
    
    // MARK: Private
    private let fetchGiftCardsUseCase: FetchGiftCardsUseCase
    
    // MARK: Initializer
    init(fetchGiftCardsUseCase: FetchGiftCardsUseCase) {
        self.fetchGiftCardsUseCase = fetchGiftCardsUseCase
    }
    
    // MARK: Computed Properties
    var giftCards: [GiftCard] {
        state.giftCards
    }
    
    var isLoading: Bool {
        state.isLoading
    }
    
    var error: NetworkError? {
        state.error
    }
    
    // MARK: -  fetchGiftCards
    @MainActor
    func fetchGiftCards() async {
        state = .loading
        
        let result = await fetchGiftCardsUseCase.execute()
        switch result {
        case .success(let cards):
            state = .loaded(cards)
        case .failure(let error):
            state = .error(error)
        }
    }
}
