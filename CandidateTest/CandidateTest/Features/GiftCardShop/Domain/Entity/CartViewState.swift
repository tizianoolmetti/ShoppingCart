//
//  CartViewState.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

enum CartViewState {
    case idle
    case loading
    case loaded(GiftCard)
    case error(NetworkError)
}

extension CartViewState: Equatable {
    static func == (lhs: CartViewState, rhs: CartViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
