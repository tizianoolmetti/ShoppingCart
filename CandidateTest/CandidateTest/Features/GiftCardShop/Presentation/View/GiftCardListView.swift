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
// MARK: - Preview Helpers
private extension GiftCardListView_Previews {
    // Mock network error for preview error states
    struct NetworkErrorMock: LocalizedError {
        let errorDescription: String?
        
        init(_ description: String) {
            self.errorDescription = description
        }
    }
    
    static let mockNetworkError = NetworkErrorMock("Failed to load gift cards. Please try again.")
    
    // Mock use case for fetching gift cards in previews
    class PreviewFetchGiftCardsUseCase: FetchGiftCardsUseCase {
        let previewState: ViewState
        
        init(state: ViewState = .loaded(GiftCard.mockCards)) {
            self.previewState = state
        }
        
        func execute() async -> Result<[GiftCard], NetworkError> {
            switch previewState {
            case .loading, .idle:
                return .success([])
            case .loaded(let cards):
                return .success(cards)
            case .error:
                return await .failure(.networkError(mockNetworkError))
            }
        }
    }
    
    // Helper method to create a view model with specific state
    static func createViewModel(state: ViewState) -> GiftCardListViewModel {
        let viewModel = GiftCardListViewModel(
            fetchGiftCardsUseCase: PreviewFetchGiftCardsUseCase(state: state)
        )
        
        viewModel.state = state
        
        return viewModel
    }
    
    // Creates a mock shopping cart view model for preview
    static func createMockShoppingCartViewModel() -> ShoppingCartViewModel {
        // Mock implementation of BuyGiftCardUseCase
        class MockBuyGiftCardUseCase: BuyGiftCardUseCase {
            func execute(purchases: [GiftCardPurchase]) async throws -> OrderConfirmation {
                return OrderConfirmation(
                    orderId: "TEST-123",
                    status: .confirmed,
                    timestamp: Date(),
                    items: [],
                    totalAmount: 0.0
                )
            }
        }
        
        return ShoppingCartViewModel(buyGiftCardUseCase: MockBuyGiftCardUseCase())
    }
}

// MARK: - Preview Provider
struct GiftCardListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GiftCardListView(viewModel: createViewModel(state: .loaded(GiftCard.mockCards)))
                .previewDisplayName("Loaded State")
            
            GiftCardListView(viewModel: createViewModel(state: .loaded(GiftCard.mockCards)))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
        }
        .environmentObject(createMockShoppingCartViewModel())
    }
}
#endif
