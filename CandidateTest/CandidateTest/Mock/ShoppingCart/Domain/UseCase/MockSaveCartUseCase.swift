//
//  MockSaveCartUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 17/11/2024.
//

import Foundation

final class MockSaveCartUseCase: SaveCartUseCase {
    
    // MARK: Properties
    private(set) var wasSaveCalled = false
    private(set) var lastSavedItems: [GiftCardPurchase]?
    var shouldFail = false
    
    // MARK: Methods
    func execute(items: [GiftCardPurchase]) async throws {
        wasSaveCalled = true
        lastSavedItems = items
        
        if shouldFail {
            throw ShoppingCartError.saveFailed
        }
    }
}
