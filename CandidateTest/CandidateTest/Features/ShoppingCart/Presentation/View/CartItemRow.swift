//
//  CartItemRow.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import SwiftUI

struct CartItemRow: View {
    // MARK: Properties
    let item: GiftCardPurchase
    let onRemove: () -> Void
    
    // MARK: Body
    var body: some View {
        HStack(alignment: .top, spacing: Layout.ShoppingCart.rowSpacing) {
            VStack(alignment: .leading, spacing: Layout.Spacing.xSmall) {
                Text("\(item.brand)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(Strings.ShoppingCart.items) \(item.giftCardId)")
                    .font(.caption)
                
                Text(Strings.GiftCardDetails.selectAmount)
                    .font(.subheadline)
                    .foregroundColor(Style.Colors.Text.secondary)
                
                ForEach(item.denominations, id: \.price) { denomination in
                    Text("\(denomination.currency) \(denomination.price, specifier: "%.2f")")
                        .font(.subheadline)
                }
            }
            
            Spacer()
            
            Button(action: onRemove) {
                Image(systemName: SystemImages.trash)
                    .foregroundColor(Style.Colors.ShoppingCart.removeButtonBackground)
            }
            .buttonStyle(.plain)
        }
        .padding(Layout.ShoppingCart.listPadding)
        .background(Style.Colors.ShoppingCart.cardBackground)
        .cornerRadius(Layout.Radius.xSmall)
    }
}

#if DEBUG
// MARK: - Preview
struct CartItemRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CartItemRow(
                item: GiftCardPurchase(
                    giftCardId: "exampleId",
                    brand: "Example Brand",
                    denominations: [
                        Denomination.mockDenomination(),
                        Denomination.mockDenomination(),
                    ]
                ),
                onRemove: {}
            )
            .previewLayout(.sizeThatFits)
            
            CartItemRow(
                item: GiftCardPurchase(
                    giftCardId: "exampleId",
                    brand: "Example Brand",
                    denominations: [
                        Denomination.mockDenomination(),
                        Denomination.mockDenomination(),
                    ]
                ),
                onRemove: {}
            )
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}
#endif
