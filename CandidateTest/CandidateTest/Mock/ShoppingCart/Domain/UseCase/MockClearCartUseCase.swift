//
//  MockClearCartUseCase.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 17/11/2024.
//

import Foundation

final class MockClearCartUseCase: ClearCartUseCase {
    // MARK: Properties
    private(set) var wasClearCalled = false
    var shouldFail = false
    
    // MARK: Methods
    func execute() async throws {
        wasClearCalled = true
        
        if shouldFail {
            throw ShoppingCartError.clearFailed
        }
    }
}
