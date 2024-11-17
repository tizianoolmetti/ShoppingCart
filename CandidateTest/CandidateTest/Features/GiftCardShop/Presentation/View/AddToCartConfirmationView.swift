//
//  AddToCartConfirmationView.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 16/11/2024.
//

import SwiftUI

struct AddToCartConfirmationView: View {
    
    // MARK: Binding
    @Binding var isPresented: Bool
    
    // MARK: Properties
    var message: String = Strings.GiftCardDetails.addedToCart
    var systemImageName: String = SystemImages.success
    
    // MARK: Body
    var body: some View {
        if isPresented {
            VStack {
                Spacer()
                HStack(spacing: Layout.Spacing.small) {
                    Image(systemName: systemImageName)
                        .font(.system(size: Layout.Size.iconSize))
                        .foregroundColor(Style.Colors.success)
                    
                    Text(message)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(Layout.Radius.medium)
                .shadow(radius: 2)
                
                Spacer()
            }
            .padding()
            .background(Color.clear)
            .transition(.opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#if DEBUG
// MARK: - Preview
struct AddToCartConfirmationView_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        Group {
            AddToCartConfirmationView(
                isPresented: $isPresented,
                message: "Added to Cart",
                systemImageName: "checkmark.circle"
            )
            
            AddToCartConfirmationView(
                isPresented: $isPresented,
                message: "Added to Cart",
                systemImageName: "checkmark.circle"
            )
            .preferredColorScheme(.dark)
        }
    }
}
#endif
