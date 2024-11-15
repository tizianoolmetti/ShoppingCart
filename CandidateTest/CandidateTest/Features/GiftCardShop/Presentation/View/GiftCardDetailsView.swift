//
//  GiftCardDetailsView.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import SwiftUI

struct GiftCardDetailsView: View {
    // MARK: Environment
    @Environment(\.presentationMode) private var presentationMode

    // MARK: State Object
    @StateObject private var viewModel: GiftCardDetailsViewModel
    
    // MARK: State
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 5)
    
    // MARK: Private properties
    private let cardDimension: CGFloat = 56
    
    // MARK: Properties
    let id: String
    
    // MARK: Initializers
    init(id: String) {
        self.id = id
        _viewModel = StateObject(wrappedValue: DIContainer.resolve(GiftCardDetailsViewModel.self))
    }

    // MARK: Body
    var body: some View {
        ZStack(alignment: .top) {
            content
                .edgesIgnoringSafeArea(.top)
            
            closeButton
                .padding(.leading, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            Task {
                await viewModel.fetchGiftCard(with: id)
            }
        }
    }
}

// MARK: Subviews
private extension GiftCardDetailsView {
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            ZStack {
                Circle()
                    .fill(Color.black.opacity(0.3))
                    .frame(width: 36, height: 36)
                
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
        case .loading:
            loadingView
        case .loaded(let giftCard):
            detailsContent(giftCard)
        case .error(let error):
            ErrorView(error: error) {
                Task {
                    await viewModel.fetchGiftCard(with: id)
                }
            }
        }
    }

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading gift card details...")
                .foregroundColor(.secondary)
        }
    }

    private func detailsContent(_ giftCard: GiftCard) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                headerSection(giftCard)
                contentSection(giftCard)
                cartButtons
            }
        }
        .background(Color(.systemBackground))
    }

    private func headerSection(_ giftCard: GiftCard) -> some View {
        ZStack(alignment: .bottomLeading) {
            ImageUrl(giftCard.image)
                .frame(height: 250)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [
                    .clear,
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(giftCard.brand)
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                
                Text(giftCard.vendor)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.bottom, 24)
            .padding(.horizontal)
        }
        .frame(height: 250)
    }

    private func contentSection(_ giftCard: GiftCard) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            denominationsSection(giftCard)
            infoSection(giftCard)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private func denominationsSection(_ giftCard: GiftCard) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Select Amount")
                .font(.title3)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: gridColumns, spacing: 8) {
                ForEach(giftCard.denominations, id: \.self) { denomination in
                    denominationCell(denomination)
                }
            }
        }
        .padding(.top, 16)
    }

    private func denominationCell(_ denomination: Denomination) -> some View {
        let isSelected = viewModel.selectedDenominations.contains(denomination)
        let isInStock = denomination.stock == "IN_STOCK"
        
        return Button(action: {
            viewModel.toggleDenomination(denomination)
        }) {
            VStack(spacing: 1) {
                Text("\(Int(denomination.price))")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                Text(denomination.currency)
                    .font(.system(.caption2, design: .rounded))
            }
            .foregroundColor(isInStock ? .white : .secondary)
            .frame(width: cardDimension, height: cardDimension)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue : (isInStock ? Color.green.opacity(0.8) : Color.gray.opacity(0.2)))
            )
        }
        .disabled(!isInStock)
    }

    private var cartButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                viewModel.handleAddToCart()
            }) {
                HStack {
                    Image(systemName: "cart")
                    Text("Add to Cart (\(viewModel.selectedDenominations.count))")
                    Text(viewModel.formattedTotalAmount)
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.selectedDenominations.isEmpty ? Color.gray.opacity(0.8) : Color.purple.opacity(0.8))
                .cornerRadius(12)
            }
            .disabled(viewModel.selectedDenominations.isEmpty)
            
            Button(action: {
                viewModel.handleBuyNow()
            }) {
                Text("Buy Now \(viewModel.formattedTotalAmount)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedDenominations.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
            }
            .disabled(viewModel.selectedDenominations.isEmpty)

            
        }
        .padding(.horizontal, 16)
    }

    private func infoSection(_ giftCard: GiftCard) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            DisclosureGroup(
                isExpanded: $viewModel.isTermsExpanded,
                content: {
                    Text(giftCard.terms.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                },
                label: {
                    Text("Terms and Conditions")
                        .font(.headline)
                }
            )
            
            DisclosureGroup(
                isExpanded: $viewModel.isInstructionsExpanded,
                content: {
                    Text(giftCard.importantContent.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                },
                label: {
                    Text("How to Use")
                        .font(.headline)
                }
            )
        }
        .foregroundColor(.primary)
    }
}

// MARK: - Preview
#if DEBUG
struct GiftCardDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GiftCardDetailsView(id: "fc453863-7abe-4b79-a144-4543b8629cff")
            
            GiftCardDetailsView(id: "fc453863-7abe-4b79-a144-4543b8629cff")
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
#endif
