//
//  MockLoadCartUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 17/11/2024.
//

import Foundation

final class MockLoadCartUseCase: LoadCartUseCase {
    
    // MARK: Properties
    private(set) var wasLoadCalled = false
    var mockItems: [GiftCardPurchase] = []
    var shouldFail = false
    
    // MARK: Methods
    func execute() async throws -> [GiftCardPurchase] {
        wasLoadCalled = true
        
        if shouldFail {
            throw ShoppingCartError.loadFailed
        }
        
        return mockItems
    }
}
