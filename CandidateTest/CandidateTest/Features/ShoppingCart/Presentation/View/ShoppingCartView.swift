//
//  ShoppingCartView.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import SwiftUI

struct ShoppingCartView: View {
    // MARK: Environment Object
    @EnvironmentObject private var viewModel: ShoppingCartViewModel
    
    // MARK: Environment
    @Environment(\.presentationMode) private var presentationMode
    
    // MARK: Body
    var body: some View {
        NavigationView {
            Group {
                ZStack {
                    if !viewModel.hasItems {
                        emptyCartView
                    } else {
                        cartItemsList
                    }
                    
                    PurchaseStateView(state: $viewModel.purchaseState) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle(Strings.ShoppingCart.title)
        }
    }
}

// MARK: - Subviews
private extension ShoppingCartView{
    private var emptyCartView: some View {
        VStack(spacing: Layout.Spacing.small) {
            Image(systemName: SystemImages.cart)
                .font(.system(size: Layout.ShoppingCart.emptyCartIconSize))
                .foregroundColor(Style.Colors.ShoppingCart.emptyCartIcon)
            Text(Strings.ShoppingCart.emptyCart)
                .font(.headline)
                .foregroundColor(Style.Colors.ShoppingCart.emptyCartIcon)
        }
    }
    
    private var cartItemsList: some View {
        VStack(spacing: 0) {
            ScrollView {
                LazyVStack(spacing: Layout.ShoppingCart.cartItemSpacing, pinnedViews: [.sectionHeaders]) {
                    ForEach(viewModel.items, id: \.id) { item in
                        CartItemRow(item: item) {
                            viewModel.remove(giftCardId: item.brand)
                        }
                    }
                }
                .padding(Layout.ShoppingCart.listPadding)
            }
            
            checkoutButton
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var checkoutButton: some View {
        VStack(spacing: Layout.Spacing.xSmall) {
            Button {
                Task {
                    await viewModel.checkout()
                }
            } label: {
                Text("\(Strings.ShoppingCart.checkout) \(viewModel.formattedTotalAmount)")
                    .fontWeight(.semibold)
                    .foregroundColor(Style.Colors.Text.white)
                    .frame(maxWidth: .infinity)
                    .padding(Layout.ShoppingCart.bottomBarPadding)
                    .background(Style.Colors.ShoppingCart.checkoutButton)
                    .cornerRadius(Layout.Radius.xSmall)
            }
            .buttonStyle(.plain)
            
            Button {
                viewModel.clear()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text(Strings.ShoppingCart.removeAll)
                    .fontWeight(.semibold)
                    .foregroundColor(Style.Colors.Text.white)
                    .frame(maxWidth: .infinity)
                    .padding(Layout.ShoppingCart.bottomBarPadding)
                    .background(Style.Colors.ShoppingCart.removeAllButton)
                    .cornerRadius(Layout.Radius.xSmall)
            }
            .buttonStyle(.plain)
            .padding(.bottom)
        }
        .padding(Layout.ShoppingCart.bottomBarPadding)
        .background(Style.Colors.ShoppingCart.cardBackground)
    }
}

#if DEBUG
#if DEBUG
// MARK: - Preview Mocks
private extension ShoppingCartView_Previews {
    
    class MockBuyGiftCardUseCase: BuyGiftCardUseCase {
        func execute(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation {
            // Simula un ritardo di rete
            try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            return OrderConfirmation.mockOrderConfirmation()
        }
    }
    
    static func createMockViewModel(withItems: Bool) -> ShoppingCartViewModel {
        let viewModel = ShoppingCartViewModel(
            buyGiftCardUseCase: MockBuyGiftCardUseCase()
        )
        
        if withItems {
            // Aggiungi alcuni elementi al carrello
            viewModel.items = GiftCardPurchase.mockPurchases
        }
        
        return viewModel
    }
}

// MARK: - Preview Provider
struct ShoppingCartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview con carrello vuoto
            ShoppingCartView()
                .environmentObject(createMockViewModel(withItems: false))
                .previewDisplayName("Empty Cart")
            
            // Preview con elementi nel carrello
            ShoppingCartView()
                .environmentObject(createMockViewModel(withItems: true))
                .previewDisplayName("Cart with Items")
            
            // Preview in stato di acquisto
            ShoppingCartView()
                .environmentObject({
                    let vm = createMockViewModel(withItems: true)
                    vm.purchaseState = .purchasing
                    return vm
                }())
                .previewDisplayName("Purchasing State")
            
            // Preview con errore
            ShoppingCartView()
                .environmentObject({
                    let vm = createMockViewModel(withItems: true)
                    vm.purchaseState = .error(NSError(domain: "PreviewError",
                                                    code: 1,
                                                    userInfo: [NSLocalizedDescriptionKey: "Network error"]))
                    return vm
                }())
                .previewDisplayName("Error State")
            
            // Preview con acquisto completato
            ShoppingCartView()
                .environmentObject({
                    let vm = createMockViewModel(withItems: true)
                    vm.purchaseState = .completed(OrderConfirmation.mockOrderConfirmation())
                    return vm
                }())
                .previewDisplayName("Completed State")
        }
    }
}
#endif
#endif
