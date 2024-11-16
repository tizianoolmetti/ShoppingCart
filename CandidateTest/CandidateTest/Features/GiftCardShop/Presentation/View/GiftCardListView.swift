//
//  GiftCardListView.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import SwiftUI

struct GiftCardListView: View {
    // MARK: State Object
    @StateObject private var viewModel: GiftCardListViewModel
    
    // MARK: Private Properties
    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: Layout.Grid.minimumItemWidth), spacing: Layout.Spacing.small),
        GridItem(.flexible(minimum: Layout.Grid.minimumItemWidth), spacing: Layout.Spacing.small)
    ]
    
    // MARK: Initializer
    init(viewModel: GiftCardListViewModel = DIContainer.resolve(GiftCardListViewModel.self)) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: Body
    var body: some View {
        content
            .onAppear {
                Task {
                    await viewModel.fetchGiftCards()
                }
            }
    }
}

// MARK: -  Subviews
private extension GiftCardListView {
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
        case .loading:
            loadingView
        case .loaded:
            giftCardList
        case .error(let error):
            ErrorView(error: error) {
                Task {
                    await viewModel.fetchGiftCards()
                }
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: Layout.Spacing.small) {
            ProgressView()
                .scaleEffect(Layout.Size.loadingIndicatorScale)
            Text(Strings.GiftCardList.loadingMessage)
                .foregroundColor(.secondary)
        }
    }
    
    private var giftCardList: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(Strings.GiftCardList.title)
                    .font(.title)
                    .padding(.top, Layout.Spacing.small)
                
                Spacer()
                
                CartButton()
            }
            
            ScrollView(showsIndicators: false) {
                Text(Strings.GiftCardList.subtitle)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.vertical, Layout.Spacing.small)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(
                    columns: columns,
                    spacing: Layout.Spacing.small
                ) {
                    ForEach(viewModel.giftCards) { card in
                        GiftCardView(giftCard: card)
                    }
                }
            }
        }
        .padding(.horizontal, Layout.Spacing.small)
    }
}

#if DEBUG
// MARK: - Preview
struct GiftCardListView_Previews: PreviewProvider {
    static var previews: some View {
        GiftCardListView(viewModel: GiftCardListViewModel.init(fetchGiftCardsUseCase: PreviewFetchGiftCardsUseCase()))
    }
    
    class PreviewFetchGiftCardsUseCase: FetchGiftCardsUseCase {
        func execute() async -> Result<[GiftCard], NetworkError> {
            print("PreviewFetchGiftCardsUseCase is called")
            let sampleGiftCards: [GiftCard] = [
                GiftCard(
                    vendor: "Eonx",
                    id: "0f3f7b67-6f75-4f0b-9ed9-b746c2eb0bd6",
                    brand: "Kmart",
                    image: "https://ucarecdn.com/dc80ba04-d334-42c8-84bb-07512c480bdf/",
                    denominations: [
                        Denomination(price: 50, currency: "AUD", stock: "IN_STOCK"),
                        Denomination(price: 100, currency: "AUD", stock: "IN_STOCK"),
                        Denomination(price: 500, currency: "AUD", stock: "IN_STOCK")
                    ],
                    position: 1,
                    merchantId: "66484",
                    terms: "<div><strong>Key conditions of use:</strong></div>",
                    isFixedValue: true,
                    importantContent: "<ol><li><p>Print this page</p></li></ol>",
                    cardTypeStatus: "AVAILABLE",
                    disclaimer: "",
                    customDenominations: nil
                )
            ]
            return .success(sampleGiftCards)
        }
    }
}
#endif
