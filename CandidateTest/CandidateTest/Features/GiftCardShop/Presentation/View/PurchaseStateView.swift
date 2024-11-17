//
//  PurchaseStateView.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 16/11/2024.
//

import SwiftUI

struct PurchaseStateView: View {
    // MARK: Properties
    @Binding var state: PurchaseState
    let doneAction: () -> Void
    
    // MARK: Body
    var body: some View {
        switch state {
        case .purchasing:
            purchasingView
        case .error(let error):
            errorView(error)
        case .completed:
            completedView
        case .idle:
            EmptyView()
        }
    }
    
    // MARK: Private Views
    private var purchasingView: some View {
        ZStack {
            Style.Colors.modalBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: Layout.Spacing.small) {
                ProgressView()
                    .scaleEffect(Layout.Size.loadingIndicatorScale)
                    .colorScheme(.dark)
                Text(Strings.GiftCardDetails.Purchase.processing)
                    .foregroundColor(Style.Colors.Text.white)
            }
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        ZStack {
            Style.Colors.modalBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: Layout.Spacing.small) {
                Image(systemName: SystemImages.error)
                    .font(.system(size: Layout.Size.iconSize))
                    .foregroundColor(Style.Colors.error)
                
                Text(Strings.GiftCardDetails.Purchase.failed)
                    .font(.headline)
                    .foregroundColor(Style.Colors.Text.white)
                
                Text(error.localizedDescription)
                    .font(.subheadline)
                    .foregroundColor(Style.Colors.Text.white.opacity(Style.Opacity.overlay))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    state = .idle
                }) {
                    Text(Strings.GiftCardDetails.Purchase.tryAgain)
                        .fontWeight(.semibold)
                        .foregroundColor(Style.Colors.Text.white)
                        .padding(.vertical, Layout.Spacing.modalActionButtonPadding)
                        .padding(.horizontal, Layout.Spacing.medium)
                        .background(Style.Colors.selectedButton)
                        .cornerRadius(Layout.Radius.xxSmall)
                }
                .padding(.top, Layout.Spacing.xSmall)
            }
            .padding()
        }
    }
    
    private var completedView: some View {
        ZStack {
            Style.Colors.modalBackground
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: Layout.Spacing.small) {
                Image(systemName: SystemImages.success)
                    .font(.system(size: Layout.Size.iconSize))
                    .foregroundColor(Style.Colors.success)
                
                Text(Strings.GiftCardDetails.Purchase.successful)
                    .font(.headline)
                    .foregroundColor(Style.Colors.Text.white)
                
                Text(Strings.GiftCardDetails.Purchase.emailDelivery)
                    .font(.subheadline)
                    .foregroundColor(Style.Colors.Text.white.opacity(Style.Opacity.overlay))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button(action: {
                    state = .idle
                    doneAction()
                }) {
                    Text(Strings.GiftCardDetails.Purchase.done)
                        .fontWeight(.semibold)
                        .foregroundColor(Style.Colors.Text.white)
                        .padding(.vertical, Layout.Spacing.modalActionButtonPadding)
                        .padding(.horizontal, Layout.Spacing.medium)
                        .background(Style.Colors.success)
                        .cornerRadius(Layout.Radius.xxSmall)
                }
                .padding(.top, Layout.Spacing.xSmall)
            }
            .padding()
        }
        .transition(.opacity)
    }
}

#if DEBUG
// MARK: - Preview
struct PurchaseStateView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewHelper()
    }
    
    private struct PreviewHelper: View {
        @State private var state: PurchaseState = .idle
        @State private var showControls = true
        
        var body: some View {
            ZStack {
                Color.gray.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                
                if showControls {
                    VStack(spacing: 16) {
                        Text("Current State: \(stateDescription)")
                            .font(.headline)
                        
                        Button("Show Purchasing") {
                            state = .purchasing
                        }
                        
                        Button("Show Error") {
                            state = .error(
                                NSError(domain: "PreviewError",
                                        code: 1,
                                        userInfo: [NSLocalizedDescriptionKey: "This is a preview error message"]
                                       )
                            )
                        }
                        
                        Button("Show Completed") {
                            let confirmation = OrderConfirmation(orderId: "1234",
                                                                 status: .confirmed,
                                                                 timestamp: Date(),
                                                                 items: [],
                                                                 totalAmount: 100)
                            state = .completed(confirmation)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
                
                PurchaseStateView(state: $state) {
                    print("Done action triggered")
                }
            }
        }
        
        private var stateDescription: String {
            switch state {
            case .idle: return "Idle"
            case .purchasing: return "Purchasing"
            case .error: return "Error"
            case .completed: return "Completed"
            }
        }
    }
}
#endif
