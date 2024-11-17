//
//  ShoppingCartError.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 16/11/2024.
//

import Foundation

enum ShoppingCartError: LocalizedError {
    case loadFailed
    case saveFailed
    case clearFailed
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .loadFailed:
            return "Failed to load shopping cart"
        case .saveFailed:
            return "Failed to save shopping cart"
        case .clearFailed:
            return "Failed to clear shopping cart"
        case .purchaseFailed:
            return "Failed to process purchase"
        }
    }
}
