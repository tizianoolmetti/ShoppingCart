//
//  CartButton.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import SwiftUI

struct CartButton: View {
    // MARK: - Properties
    @State private var showCart = false
    @EnvironmentObject private var cartViewModel: ShoppingCartViewModel
    
    // MARK: - Body
    var body: some View {
        Button {
            showCart = true
        } label: {
            HStack(spacing: Layout.Spacing.xSmall) {
                Image(systemName: SystemImages.cart)
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
            .cornerRadius(Layout.Radius.xSmall)
        }
        .sheet(isPresented: $showCart) {
            ShoppingCartView()
                .environmentObject(cartViewModel)
        }
    }
}

// MARK: - Preview
struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        CartButton()
            .environmentObject(ShoppingCartViewModel(buyGiftCardUseCase: DIContainer.resolve(BuyGiftCardUseCase.self)))
            .previewLayout(.sizeThatFits)
    }
}