//
//  PurchaseState.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

enum PurchaseState {
    case idle
    case purchasing
    case completed(OrderConfirmation)
    case error(Error)
}

extension PurchaseState: Equatable {
    static func == (lhs: PurchaseState, rhs: PurchaseState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.purchasing, .purchasing):
            return true
        case (.completed, .completed):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
