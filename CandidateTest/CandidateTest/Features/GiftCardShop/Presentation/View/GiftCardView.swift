//
//  GiftCardView.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import SwiftUI
// MARK: - GiftCardView
struct GiftCardView: View {
    // MARK: EnvironmentObject
    @EnvironmentObject private var cartViewModel: ShoppingCartViewModel
    
    // MARK: State
    @State private var showDetails = false
    
    // MARK: Properties
    let giftCard: GiftCard
    
    // MARK: Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageSection
            contentSection
        }
        .background(Color(.systemBackground))
        .cornerRadius(Layout.Radius.xxSmall)
        .shadow(radius: 1, x: 0, y:1)
        .overlay(
            RoundedRectangle(cornerRadius: Layout.Radius.xxSmall)
                .stroke(Color.gray.opacity(Style.Opacity.border), lineWidth: Layout.Size.borderWidth)
        )
        .fullScreenCover(isPresented: $showDetails) {
            GiftCardDetailsView(id: giftCard.id)
                .environmentObject(cartViewModel)
        }
    }
}

// MARK: - Subviews
private extension GiftCardView {
    
    @ViewBuilder
    var imageSection: some View {
        ImageUrl(giftCard.image)
            .aspectRatio(contentMode: .fill)
            .frame(height: Layout.Size.cardImageHeight)
            .clipped()
    }
    
    var contentSection: some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.xSmall) {
            titleSection
            detailsButton
        }
        .padding(Layout.Spacing.xSmall)
    }
    
    var titleSection: some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.xxxSmall) {
            Text(giftCard.brand)
                .font(.subheadline)
                .bold()
                .lineLimit(1)
            
            Text(giftCard.vendor)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
    
    var detailsButton: some View {
        HStack {
            Spacer()
            Button(action: {
                showDetails = true
            }) {
                Text(Strings.GiftCard.details)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.vertical, Layout.Spacing.xxSmall)
                    .padding(.horizontal, Layout.Spacing.xSmall)
            }
            .background(Style.Colors.buttonOverlay)
            .cornerRadius(Layout.Radius.xxxSmall)
        }
    }
}

#if DEBUG
// MARK: - Preview
struct GiftCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GiftCardView(giftCard: .kmartCard)
                .frame(width: Layout.Size.cardWidth)
                .previewDisplayName("Kmart Card")
            
            GiftCardView(giftCard: .woolworthsCard)
                .frame(width: Layout.Size.cardWidth)
                .previewDisplayName("Woolworths Card")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
