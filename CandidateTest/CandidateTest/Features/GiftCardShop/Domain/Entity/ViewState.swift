//
//  ViewState.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

enum ViewState {
    case idle
    case loading
    case loaded([GiftCard])
    case error(NetworkError)
    
    var giftCards: [GiftCard] {
        if case .loaded(let cards) = self {
            return cards
        }
        return []
    }
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var error: NetworkError? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
}
