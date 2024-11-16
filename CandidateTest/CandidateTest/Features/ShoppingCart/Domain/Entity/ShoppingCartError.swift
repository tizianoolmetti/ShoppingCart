//
//  ShoppingCartError.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 16/11/2024.
//

import Foundation

enum ShoppingCartError: LocalizedError {
    case purchaseFailed
    
    var errorDescription: String? {
        switch self {
        case .purchaseFailed:
            return "Failed to process purchase"
        }
    }
}
