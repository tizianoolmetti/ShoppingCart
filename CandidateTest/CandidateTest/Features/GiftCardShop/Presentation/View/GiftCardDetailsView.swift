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
    @EnvironmentObject private var cartViewModel: ShoppingCartViewModel
    
    // MARK: State Object
    @StateObject private var viewModel: GiftCardDetailsViewModel
    
    // MARK: State
    @State private var gridColumns = Array(repeating: GridItem(.flexible(), spacing: Layout.Spacing.xSmall), count: Layout.Grid.denominationsColumnCount)
    @State private var showAddToCartConfirmation = false
    
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
                .padding(.leading, Layout.Spacing.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            CartButtonView
            
            PurchaseStateView(state: $viewModel.purchaseState) {
                presentationMode.wrappedValue.dismiss()
            }
            
            AddToCartConfirmationView(isPresented: $showAddToCartConfirmation)
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
    @ViewBuilder
    private var closeButton: some View {
        if viewModel.isLoaded {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.black.opacity(Style.Opacity.medium))
                        .frame(width: Layout.Size.closeButtonSize, height: Layout.Size.closeButtonSize)
                    
                    Image(systemName: SystemImages.close)
                        .font(.system(size: Layout.Spacing.small, weight: .bold))
                        .foregroundColor(Style.Colors.Text.white)
                }
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
        VStack(spacing: Layout.Spacing.small) {
            ProgressView()
                .scaleEffect(Layout.Size.loadingIndicatorScale)
            Text(Strings.GiftCardDetails.loading)
                .foregroundColor(Style.Colors.Text.secondary)
        }
    }
    
    @ViewBuilder
    private var CartButtonView: some View {
        if viewModel.isLoaded {
            CartButton()
                .padding(.trailing, Layout.Spacing.medium)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private func detailsContent(_ giftCard: GiftCard) -> some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection(giftCard)
                    contentSection(giftCard)
                    Spacer()
                }
            }
            
            VStack(spacing: Layout.Spacing.small) {
                addToCartButton
                buyNowButton
            }
            .padding(.horizontal, Layout.Spacing.medium)
            .padding(.bottom, Layout.Spacing.medium)
            .background(Color(.systemBackground))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func headerSection(_ giftCard: GiftCard) -> some View {
        ZStack(alignment: .bottomLeading) {
            ImageUrl(giftCard.image)
                .frame(height: Layout.Size.headerImageHeight)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [
                    .clear,
                    Color.black.opacity(Style.Opacity.medium),
                    Color.black.opacity(Style.Opacity.heavy)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: Layout.Spacing.xSmall) {
                Text(giftCard.brand)
                    .font(.title)
                    .bold()
                    .foregroundColor(Style.Colors.Text.white)
                
                Text(giftCard.vendor)
                    .font(.headline)
                    .foregroundColor(Style.Colors.Text.white.opacity(Style.Opacity.overlay))
            }
            .padding(.bottom, Layout.Spacing.medium)
            .padding(.horizontal)
        }
        .frame(height: Layout.Size.headerImageHeight)
    }
    
    private func contentSection(_ giftCard: GiftCard) -> some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.medium) {
            denominationsSection(giftCard)
            infoSection(giftCard)
        }
        .padding(.horizontal, Layout.Spacing.medium)
        .padding(.bottom, Layout.Spacing.small)
    }
    
    private func denominationsSection(_ giftCard: GiftCard) -> some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.small) {
            Text(Strings.GiftCardDetails.selectAmount)
                .font(.title3)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: gridColumns, spacing: Layout.Spacing.modalActionButtonPadding) {
                ForEach(giftCard.denominations, id: \.self) { denomination in
                    denominationCell(denomination)
                }
            }
        }
        .padding(.top, Layout.Spacing.small)
    }
    
    private func denominationCell(_ denomination: Denomination) -> some View {
        let isSelected = viewModel.selectedDenominations.contains(denomination)
        let isInStock = denomination.stock == "IN_STOCK"
        
        return Button(action: {
            viewModel.toggleDenomination(denomination)
        }) {
            VStack(spacing: Layout.Spacing.xxxSmall) {
                Text("\(Int(denomination.price))")
                    .font(.system(.subheadline, design: .rounded))
                    .bold()
                Text(denomination.currency)
                    .font(.system(.caption2, design: .rounded))
            }
            .foregroundColor(isInStock ? Style.Colors.Text.white : Style.Colors.Text.secondary)
            .frame(width: Layout.Size.denominationCardSize, height: Layout.Size.denominationCardSize)
            .background(
                RoundedRectangle(cornerRadius: Layout.Radius.xxSmall)
                    .fill(isSelected ? Style.Colors.selectedButton :
                            (isInStock ? Style.Colors.inStockButton : Style.Colors.disabledButton))
            )
        }
        .disabled(!isInStock)
    }
    
    private var addToCartButton: some View {
        Button(action: handleAddToCart) {
            HStack {
                Image(systemName: SystemImages.cart)
                Text("\(Strings.GiftCardDetails.addToCart) (\(viewModel.selectedDenominations.count))")
                Text(viewModel.formattedTotalAmount)
            }
            .font(.headline)
            .foregroundColor(Style.Colors.Text.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                viewModel.selectedDenominations.isEmpty ?
                Style.Colors.disabledButton : Style.Colors.addToCartButton
            )
            .cornerRadius(Layout.Radius.xSmall)
        }
        .disabled(viewModel.selectedDenominations.isEmpty)
    }
    
    private var buyNowButton: some View {
        Button(action: {
            Task {
                await viewModel.handleBuyNow(id: id, brand: viewModel.giftCard?.brand ?? "")
            }
        }) {
            Text("\(Strings.GiftCardDetails.buyNow) \(viewModel.formattedTotalAmount)")
                .font(.headline)
                .foregroundColor(Style.Colors.Text.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    viewModel.selectedDenominations.isEmpty ?
                    Style.Colors.disabledButton : Style.Colors.selectedButton
                )
                .cornerRadius(Layout.Radius.xSmall)
        }
        .disabled(viewModel.selectedDenominations.isEmpty)
    }
    
    private func handleAddToCart() {
        guard let giftCard = viewModel.giftCard,
              !viewModel.selectedDenominations.isEmpty else { return }
        
        cartViewModel.add(giftCard: giftCard, denominations: viewModel.selectedDenominations)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        viewModel.selectedDenominations.removeAll()
        withAnimation {
            showAddToCartConfirmation = true
        }
    }
    
    private func infoSection(_ giftCard: GiftCard) -> some View {
        VStack(alignment: .leading, spacing: Layout.Spacing.small) {
            termsGroup(giftCard)
            instructionsGroup(giftCard)
        }
        .foregroundColor(Style.Colors.Text.primary)
    }
    
    private func termsGroup(_ giftCard: GiftCard) -> some View {
        DisclosureGroup(
            isExpanded: $viewModel.isTermsExpanded,
            content: {
                Text(giftCard.terms.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
                    .font(.subheadline)
                    .foregroundColor(Style.Colors.Text.secondary)
                    .padding(.vertical, Layout.Spacing.xSmall)
            },
            label: {
                Text(Strings.GiftCardDetails.terms)
                    .font(.headline)
            }
        )
    }
    
    private func instructionsGroup(_ giftCard: GiftCard) -> some View {
        DisclosureGroup(
            isExpanded: $viewModel.isInstructionsExpanded,
            content: {
                Text(giftCard.importantContent.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression))
                    .font(.subheadline)
                    .foregroundColor(Style.Colors.Text.secondary)
                    .padding(.vertical, Layout.Spacing.xSmall)
            },
            label: {
                Text(Strings.GiftCardDetails.howToUse)
                    .font(.headline)
            }
        )
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
        .environmentObject(DIContainer.resolve(ShoppingCartViewModel.self))
    }
}
#endif
