//
//  CandidateTestApp.swift
//  CandidateTest
//
//  Created by Adam Schmidt on 29/10/20.
//

import SwiftUI

@main
struct CandidateTestApp: App {
    @StateObject private var cartViewModel = DIContainer.resolve(ShoppingCartViewModel.self)
    
    var body: some Scene {
        WindowGroup {
            GiftCardListView()
                .environmentObject(cartViewModel)
        }
    }
}
