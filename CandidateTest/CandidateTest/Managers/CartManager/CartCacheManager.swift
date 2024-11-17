//
//  CartCacheManager.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 17/11/2024.
//

import SwiftUI

protocol CartCacheManager {
    func saveCart(_ items: [GiftCardPurchase]) throws
    func loadCart() throws -> [GiftCardPurchase]
    func clearCart() throws
}

final class CartCacheManagerImpl: CartCacheManager {
    // MARK: Properties
    private let fileManager: FileManager
    private let cacheFileName = "cart_cache.json"
    
    // MARK: Computed Properties
    private var cacheDirectory: URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    private var cacheFileURL: URL {
        cacheDirectory.appendingPathComponent(cacheFileName)
    }
    
    // MARK: Initializer
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    // MARK: Methods
    func saveCart(_ items: [GiftCardPurchase]) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(items)
        try data.write(to: cacheFileURL)
    }
    
    func loadCart() throws -> [GiftCardPurchase] {
        guard fileManager.fileExists(atPath: cacheFileURL.path) else {
            return []
        }
        
        let data = try Data(contentsOf: cacheFileURL)
        let decoder = JSONDecoder()
        return try decoder.decode([GiftCardPurchase].self, from: data)
    }
    
    func clearCart() throws {
        guard fileManager.fileExists(atPath: cacheFileURL.path) else { return }
        try fileManager.removeItem(at: cacheFileURL)
    }
}
