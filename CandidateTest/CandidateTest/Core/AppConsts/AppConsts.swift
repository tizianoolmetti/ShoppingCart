//
//  AppConsts.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 16/11/2024.
//

import SwiftUI
import SwiftUI

// MARK: - Layout Constants
enum Layout {
    enum Grid {
        static let minimumItemWidth: CGFloat = 150
        static let columnCount = 2
        static let denominationsColumnCount = 5
    }
    
    enum Spacing {
        static let xxxSmall: CGFloat = 4
        static let xxSmall: CGFloat = 8
        static let xSmall: CGFloat = 12
        static let small: CGFloat = 16
        static let medium: CGFloat = 24
        static let large: CGFloat = 32
        static let modalActionButtonPadding: CGFloat = 12
    }
    
    enum Size {
        static let loadingIndicatorScale: CGFloat = 1.5
        static let cardImageHeight: CGFloat = 100
        static let cardWidth: CGFloat = 180
        static let borderWidth: CGFloat = 1
        static let closeButtonSize: CGFloat = 36
        static let denominationCardSize: CGFloat = 56
        static let headerImageHeight: CGFloat = 250
        static let iconSize: CGFloat = 50
        static let checkMark: CGFloat = 40
    }
    
    enum Radius {
        static let xxxSmall: CGFloat = 4
        static let xxSmall: CGFloat = 8
        static let xSmall: CGFloat = 12
        static let small: CGFloat = 16
        static let medium: CGFloat = 20
    }
    
    enum ShoppingCart {
        static let emptyCartIconSize: CGFloat = 50
        static let cartItemSpacing: CGFloat = 12
        static let buttonHeight: CGFloat = 44
        static let bottomBarPadding: CGFloat = 16
        static let rowSpacing: CGFloat = 12
        static let listPadding: CGFloat = 16
        static let iconSize: CGFloat = 30
        static let buttonMinHeight: CGFloat = 48
        static let buttonStackSpacing: CGFloat = 12
        static let cornerRadius: CGFloat = 8
        static let appLogo = "app_logo"
    }
}

// MARK: - String Constants
enum Strings {
    enum GiftCardList {
        static let title = LocalizedStringKey("Good Morning")
        static let subtitle = LocalizedStringKey("Gift Cards for You")
        static let loadingMessage = LocalizedStringKey("Loading Gift Cards...")
    }
    
    enum GiftCard {
        static let details = LocalizedStringKey("Details")
    }
    
    enum GiftCardDetails {
        static let loading = LocalizedStringKey("Loading gift card details...")
        static let selectAmount = "Select Amount"
        static let terms = LocalizedStringKey("Terms and Conditions")
        static let howToUse = LocalizedStringKey("How to Use")
        static let addToCart = "Add to Cart"
        static let buyNow = "Buy Now"
        static let addedToCart = "Added to your cart."
        
        enum Purchase {
            static let processing = LocalizedStringKey("Processing purchase...")
            static let failed = LocalizedStringKey("Purchase Failed")
            static let successful = LocalizedStringKey("Purchase Successful!")
            static let emailDelivery = LocalizedStringKey("Your gift card will be delivered to your email shortly.")
            static let tryAgain = LocalizedStringKey("Try Again")
            static let done = LocalizedStringKey("Done")
        }
    }
    
    enum ShoppingCart {
        static let title = LocalizedStringKey("Cart")
        static let emptyCart = LocalizedStringKey("Your cart is empty")
        static let checkout = "Checkout"
        static let removeAll = LocalizedStringKey("Remove All")
        static let total = LocalizedStringKey("Total")
        static let items = "items"
        static let remove = LocalizedStringKey("Remove")
        static let clearCart = LocalizedStringKey("Clear Cart")
        static let confirmClear = LocalizedStringKey("Are you sure you want to clear your cart?")
        static let cancel = LocalizedStringKey("Cancel")
    }
    
    enum Common {
        static let retry = "Retry"
        static let error = "Error"
        static let loading = "Loading..."
        static let somethingWentWrong = "Something went wrong"
    }
}

// MARK: - Style Constants
enum Style {
    enum Font {
        static let titleSize: CGFloat = 28
        static let subtitleSize: CGFloat = 16
        static let bodySize: CGFloat = 14
        static let captionSize: CGFloat = 12
    }
    
    enum Opacity {
        static let disabled: CGFloat = 0.5
        static let overlay: CGFloat = 0.8
        static let border: CGFloat = 0.1
        static let light: CGFloat = 0.2
        static let medium: CGFloat = 0.3
        static let heavy: CGFloat = 0.7
        static let modal: CGFloat = 0.8
    }
    
    enum Colors {
        static let error = Color.red
        static let success = Color.green
        static let modalBackground = Color.black.opacity(Style.Opacity.modal)
        static let selectedButton = Color.blue
        static let inStockButton = Color.green.opacity(0.8)
        static let disabledButton = Color.gray.opacity(Style.Opacity.light)
        static let addToCartButton = Color.purple.opacity(0.8)
        static let buttonOverlay = Color.blue.opacity(Style.Opacity.overlay)
        
        enum Text {
            static let primary = Color.primary
            static let secondary = Color.secondary
            static let white = Color.white
        }
        
        enum Button {
            static let primary = Color.blue
            static let secondary = Color.gray
            static let success = Color.green
            static let error = Color.red
        }
        
        enum ShoppingCart {
            static let buttonBackground = Color.blue
            static let removeButtonBackground = Color.red.opacity(0.8)
            static let dividerColor = Color.gray.opacity(0.2)
            static let cardBackground = Color(.secondarySystemBackground)
            static let emptyCartIcon = Color.gray.opacity(0.5)
            static let checkoutButton = Color.blue
            static let removeAllButton = Color.red
        }
    }
}

// MARK: - System Images
enum SystemImages {
    static let close = "xmark"
    static let error = "xmark.circle.fill"
    static let success = "checkmark.circle.fill"
    static let cart = "cart"
    static let trash = "trash"
    static let retry = "arrow.clockwise"
    static let noInternet = "wifi.slash"
}
