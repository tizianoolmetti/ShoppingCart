//
//  GiftCardView.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import SwiftUI

// MARK: - GiftCardView
struct GiftCardView: View {
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
        .cornerRadius(8)
        .shadow(radius: 1, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .fullScreenCover(isPresented: $showDetails) {
            GiftCardDetailsView(id: giftCard.id)
        }
    }
}

// MARK: - Subviews
private extension GiftCardView {
    
    @ViewBuilder
    var imageSection: some View {
        if #available(iOS 15.0, *) {
            AsyncImage(url: URL(string: giftCard.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 100)
                    .overlay {
                        ProgressView()
                    }
            }
        }
    }
    
    var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            titleSection
            detailsButton
        }
        .padding(8)
    }
    
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 2) {
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
                Text("Details")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
            }
            .background(Color.blue.opacity(0.1))
            .cornerRadius(4)
        }
    }
}

#if DEBUG
// MARK: - Preview
struct GiftCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Standard Card
            GiftCardView(giftCard: .kmartCard)
                .frame(width: 180)
                .previewDisplayName("Kmart Card")
            
            // Different Denominations
            GiftCardView(giftCard: .woolworthsCard)
                .frame(width: 180)
                .previewDisplayName("Woolworths Card")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
