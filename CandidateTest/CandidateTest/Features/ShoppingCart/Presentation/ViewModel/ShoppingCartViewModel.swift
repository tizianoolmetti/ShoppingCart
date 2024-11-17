//
//  CartViewModel.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import SwiftUI

final class ShoppingCartViewModel: ObservableObject {
    // MARK: Published
    @Published var items: [GiftCardPurchase] = []
    @Published var totalAmount: Double = 0
    @Published var purchaseState: PurchaseState = .idle
    
    // MARK: Private
    private let buyGiftCardUseCase: BuyGiftCardUseCase
    private let loadCartUseCase: LoadCartUseCase
    private let saveCartUseCase: SaveCartUseCase
    private let clearCartUseCase: ClearCartUseCase
    
    // MARK: Initialization
    init(
        buyGiftCardUseCase: BuyGiftCardUseCase,
        loadCartUseCase: LoadCartUseCase,
        saveCartUseCase: SaveCartUseCase,
        clearCartUseCase: ClearCartUseCase
    ) {
        self.buyGiftCardUseCase = buyGiftCardUseCase
        self.loadCartUseCase = loadCartUseCase
        self.saveCartUseCase = saveCartUseCase
        self.clearCartUseCase = clearCartUseCase
        
        Task {
            await loadCachedItems()
        }
    }
}

// MARK: - Computed Properties
extension ShoppingCartViewModel {
    var itemCount: Int {
        items.count
    }
    
    var formattedTotalAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: totalAmount)) ?? "0"
    }
    
    var hasItems: Bool {
        !items.isEmpty
    }
}

// MARK: - Cart Management
extension ShoppingCartViewModel {
    func add(giftCard: GiftCard, denominations: [Denomination]) {
        let purchase = GiftCardPurchase(
            giftCardId: giftCard.id,
            brand: giftCard.brand,
            denominations: denominations
        )
        
        if let index = items.firstIndex(where: { $0.brand == giftCard.id }) {
            items[index] = purchase
        } else {
            items.append(purchase)
        }
        
        updateTotalAmount()
        
        Task {
            await saveItemsToCache()
        }
    }
    
    func remove(giftCardId: String) {
        withAnimation {
            items.removeAll { $0.brand == giftCardId }
            updateTotalAmount()
            
            Task {
                await saveItemsToCache()
            }
        }
    }
    
    func clear() {
        withAnimation {
            items.removeAll()
            totalAmount = 0
            
            Task {
                do {
                    try await clearCartUseCase.execute()
                } catch {
                    print("Failed to clear cart cache: \(error)")
                }
            }
        }
    }
    
    func contains(giftCardId: String) -> Bool {
        items.contains { $0.brand == giftCardId }
    }
}

// MARK: - Private Helpers
private extension ShoppingCartViewModel {
    func updateTotalAmount() {
        totalAmount = items.reduce(0) { total, purchase in
            total + purchase.denominations.reduce(0) { $0 + $1.price }
        }
    }
}

// MARK: - Checkout
extension ShoppingCartViewModel {
    @MainActor
    func checkout() async {
        guard !items.isEmpty else { return }
        
        purchaseState = .purchasing
        
        do {
            let confirmation = try await buyGiftCardUseCase.execute(purchases: items)
            purchaseState = .completed(confirmation)
            items = []
            totalAmount = 0
            try await clearCartUseCase.execute()
        } catch {
            purchaseState = .error(error)
        }
    }
}

// MARK: - Cache Management
extension ShoppingCartViewModel {
    func handleScenePhase(_ phase: ScenePhase) {
        switch phase {
        case .background, .inactive:
            Task {
                await saveItemsToCache()
            }
        case .active:
            Task {
                await loadCachedItems()
            }
        @unknown default:
            break
        }
    }
    
    @MainActor
    private func loadCachedItems() async {
        do {
            items = try await loadCartUseCase.execute()
            updateTotalAmount()
        } catch {
            print("Failed to load cached cart items: \(error)")
        }
    }
    
    private func saveItemsToCache() async {
        do {
            try await saveCartUseCase.execute(items: items)
        } catch {
            print("Failed to save cart items to cache: \(error)")
        }
    }
}

