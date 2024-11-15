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
        GridItem(.flexible(minimum: 150), spacing: 16),
        GridItem(.flexible(minimum: 150), spacing: 16)
    ]
    
    // MARK: Initializer
    init() {
        _viewModel = StateObject(wrappedValue: DIContainer.resolve(GiftCardListViewModel.self))
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
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading Gift Cards...")
                .foregroundColor(.secondary)
        }
    }
    
    private var giftCardList: some View {
        VStack(alignment: .leading) {
            Text("Good Morning")
                .font(.title)
                .padding(.top, 16)
            
            ScrollView(showsIndicators: false) {
                Text("Gift Cards for You")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                LazyVGrid(
                    columns: columns,
                    spacing: 16
                ) {
                    ForEach(viewModel.giftCards) { card in
                        GiftCardView(giftCard: card)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}


//#if DEBUG
//// MARK: - Preview
//struct GiftCardListView_Previews: PreviewProvider {
//    static var previews: some View {
//        GiftCardListView()
//    }
//}
//#endif
