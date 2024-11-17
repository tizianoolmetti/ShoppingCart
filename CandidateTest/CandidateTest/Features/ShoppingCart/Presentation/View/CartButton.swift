//
//  CartButton.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import SwiftUI

struct CartButton: View {
    // MARK: - EnvironmentObject
    @EnvironmentObject private var cartViewModel: ShoppingCartViewModel
    
    // MARK: - Properties
    @State private var showCart = false
    
    // MARK: - Body
    var body: some View {
        Button {
            showCart = true
        } label: {
            HStack(spacing: Layout.Spacing.xSmall) {
                Image(Layout.ShoppingCart.appLogo)
                    .resizable()
                    .frame(width: Layout.ShoppingCart.iconSize, height: Layout.ShoppingCart.iconSize)
                    .font(.system(size: Layout.ShoppingCart.iconSize))
                
                if cartViewModel.hasItems {
                    VStack(alignment: .leading, spacing: Layout.Spacing.xxxSmall) {
                        Text(cartViewModel.formattedTotalAmount)
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
            }
            .padding(Layout.Spacing.xSmall)
            .background(Style.Colors.ShoppingCart.cardBackground)
            .cornerRadius(Layout.Radius.small)
        }
        .accessibilityIdentifier("cartButtonIdentifier")
        .sheet(isPresented: $showCart) {
            ShoppingCartView()
                .environmentObject(cartViewModel)
        }
    }
}

#if DEBUG
// MARK: - Preview
struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        CartButton()
            .environmentObject(ShoppingCartViewModel(
                buyGiftCardUseCase: DIContainer.resolve(BuyGiftCardUseCase.self),
                loadCartUseCase: DIContainer.resolve(LoadCartUseCase.self),
                saveCartUseCase: DIContainer.resolve(SaveCartUseCase.self),
                clearCartUseCase: DIContainer.resolve(ClearCartUseCase.self)
            ))
            .previewLayout(.sizeThatFits)
    }
}
#endif
