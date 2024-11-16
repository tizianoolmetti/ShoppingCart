//
//  GiftCard.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import Foundation

struct GiftCard: Identifiable, Codable {
    let vendor: String
    let id: String
    let brand: String
    let image: String
    let denominations: [Denomination]
    let position: Int
    let merchantId: String
    let terms: String
    let isFixedValue: Bool
    let importantContent: String
    let cardTypeStatus: String
    let disclaimer: String
    let customDenominations: [CustomDenomination]?
    
    // Custom decoding initialization
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.vendor = try container.decode(String.self, forKey: .vendor)
        self.id = try container.decode(String.self, forKey: .id)
        self.brand = try container.decode(String.self, forKey: .brand)
        self.image = try container.decode(String.self, forKey: .image)
        self.denominations = try container.decode([Denomination].self, forKey: .denominations)
        self.merchantId = try container.decode(String.self, forKey: .merchantId)
        self.terms = try container.decode(String.self, forKey: .terms)
        self.isFixedValue = try container.decode(Bool.self, forKey: .isFixedValue)
        self.importantContent = try container.decode(String.self, forKey: .importantContent)
        self.cardTypeStatus = try container.decode(String.self, forKey: .cardTypeStatus)
        self.disclaimer = try container.decode(String.self, forKey: .disclaimer)
        self.customDenominations = try container.decodeIfPresent([CustomDenomination].self, forKey: .customDenominations)
        
        // Handle position that could be either String or Int
        if let positionInt = try? container.decode(Int.self, forKey: .position) {
            self.position = positionInt
        } else if let positionString = try? container.decode(String.self, forKey: .position),
                  let positionInt = Int(positionString) {
            self.position = positionInt
        } else {
            self.position = 0  // Default value if neither format works
        }
    }
    
    // Standard init for mocks
    init(
        vendor: String,
        id: String,
        brand: String,
        image: String,
        denominations: [Denomination],
        position: Int,
        merchantId: String,
        terms: String,
        isFixedValue: Bool,
        importantContent: String,
        cardTypeStatus: String,
        disclaimer: String,
        customDenominations: [CustomDenomination]?
    ) {
        self.vendor = vendor
        self.id = id
        self.brand = brand
        self.image = image
        self.denominations = denominations
        self.position = position
        self.merchantId = merchantId
        self.terms = terms
        self.isFixedValue = isFixedValue
        self.importantContent = importantContent
        self.cardTypeStatus = cardTypeStatus
        self.disclaimer = disclaimer
        self.customDenominations = customDenominations
    }
}

// MARK: - Mocks
extension GiftCard {
    static let mockCards: [GiftCard] = [
        kmartCard,
        woolworthsCard,
        uberEatsCard,
        AppleCard,
        ShellCard,
        egCard,
        ampolCard,
        colesCard
    ]
    
    static let kmartCard = GiftCard(
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
    
    static let woolworthsCard = GiftCard(
        vendor: "Eonx",
        id: "fc453863-7abe-4b79-a144-4543b8629cff",
        brand: "Woolworths",
        image: "https://ucarecdn.com/09804d2e-b535-441f-8616-3324ce4bacfc/",
        denominations: [
            Denomination(price: 5, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 10, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 25, currency: "AUD", stock: "IN_STOCK")
        ],
        position: 2,
        merchantId: "66540",
        terms: "<ol><li>Terms and conditions</li></ol>",
        isFixedValue: false,
        importantContent: "<h4>How to use</h4>",
        cardTypeStatus: "AVAILABLE",
        disclaimer: "",
        customDenominations: []
    )
    
    static let uberEatsCard = GiftCard(
        vendor: "Eonx",
        id: "6ef9c62f-3e29-4094-81c1-b666e62e67fd",
        brand: "Uber EATS",
        image: "https://ucarecdn.com/28e80d7f-fee4-4e7b-973b-b00911f9d7ca/",
        denominations: [
            Denomination(price: 10, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 25, currency: "AUD", stock: "IN_STOCK")
        ],
        position: 3,
        merchantId: "66556",
        terms: "Gift card terms for Uber Eats",
        isFixedValue: false,
        importantContent: "How to use your Uber Eats gift card",
        cardTypeStatus: "AVAILABLE",
        disclaimer: "",
        customDenominations: []
    )
    
    static let AppleCard = GiftCard(
        vendor: "Eonx",
        id: "56c7918a-a400-4354-a107-ecab44292720",
        brand: "Apple",
        image: "https://ucarecdn.com/4489bf1c-9380-42f8-85fd-fce9ba16ff40/-/crop/452x280/0,0/",
        denominations: [
            Denomination(price: 20, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 25, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 30, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 50, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 75, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 100, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 120, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 150, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 200, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 300, currency: "AUD", stock: "IN_STOCK")
        ],
        position: 3,
        merchantId: "66495",
        terms: """
                <p>A maximum of 8 Apple eGift Cards can be redeemed per order. Valid only for Australian transactions from Apple. For assistance, visit <a href="http://support.apple.com/giftcard">support.apple.com/giftcard</a> or call 1-300-321-456. Not redeemable at Apple resellers or for cash, and no resale, refunds or exchanges, except as required by law. Apple is not responsible for unauthorised use. Terms apply; see <a href="http://apple.com/au/go/legal/gc">apple.com/au/go/legal/gc</a>. These terms do not affect your statutory rights. No expiry. Issued by Apple Pty Limited. © 2021 Apple Inc. All rights reserved.</p>
                """,
        isFixedValue: false,
        importantContent: """
                <p data-pm-slice="1 1 []">Follow the instructions below to redeem your iTunes Code, or simply click on the "redeem" button to automatically redeem into your account.</p>
                <p>1. Open iTunes Store.</p>
                <p>2. Scroll to bottom and click or tap Redeem.</p>
                <p>3. Enter the 16-digit code shown above.</p>
                """,
        cardTypeStatus: "AVAILABLE",
        disclaimer: "",
        customDenominations: [
            CustomDenomination(minPrice: 3, maxPrice: 500)
        ]
    )
    
    // Shell Gift Card
    static let ShellCard = GiftCard(
        vendor: "DigitalGlue",
        id: "AUBHNSHMC002",
        brand: "Shell",
        image: "https://d2gktdeiupfo4o.cloudfront.net/images/deis/products/Shell.png",
        denominations: [
            Denomination(price: 5, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 10, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 15, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 25, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 50, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 75, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 100, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 125, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 150, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 200, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 250, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 300, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 400, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 500, currency: "AUD", stock: "IN_STOCK")
        ],
        position: 3,
        merchantId: "66207",
        terms: """
                Blackhawk Network (Australia) Pty Ltd, ABN 84 123 251 703, is the issuer of this card. Card will expire 4 years from the issue date shown on card. Lost or stolen cards cannot be replaced. For complete Terms & Conditions or customer assistance go to <a href="http://giftcards.shell.com.au">giftcards.shell.com.au</a>. For balance check or expiry date go to <a href="http://www.cardbalance.com.au">www.cardbalance.com.au</a>. We reserve the right to change these Terms & Conditions at any time if we consider it is reasonably necessary to protect our legitimate interests.
                """,
        isFixedValue: false,
        importantContent: """
                With a network of Shell service stations and convenience stores Australia-wide providing everything from fuel to coffee, snacks, car care, ice, groceries and gas bottles, a Shell Gift Card can fuel smiles anywhere!
                
                Redeemable at participating Shell branded service stations. To find a Shell eGift Card accepting store visit <a href="http://shell.com.au/fuelfinder">shell.com.au/fuelfinder</a>.
                """,
        cardTypeStatus: "AVAILABLE",
        disclaimer: "",
        customDenominations: []
    )
    
    static let egCard = GiftCard(
        vendor: "DigitalGlue",
        id: "AUBHNEGFC002",
        brand: "EG",
        image: "https://d2gktdeiupfo4o.cloudfront.net/images/deis/products/EG.png",
        denominations: [
            Denomination(price: 5, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 10, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 15, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 25, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 50, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 75, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 100, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 125, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 150, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 200, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 250, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 300, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 400, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 500, currency: "AUD", stock: "IN_STOCK")
        ],
        position: 3,
        merchantId: "66809",
        terms: """
                1. By using this eGift Card you agree to the full eGift Card Terms and Conditions.
                2. This eGift Card is redeemable at participating stores. Participating stores may change from time to time.
                Not redeemable at Ampol or Ampol Woolworths MetroGo co-branded outlets.
                3. For full Store Gift Card Terms and Conditions and a list of participating stores visit
                <a href="http://woolworths.com.au/giftcards">woolworths.com.au/giftcards</a>
                """,
        isFixedValue: false,
        importantContent: """
                There's an EG Ampol fuel site near you when you need it. With more than 500 EG Ampol
                (Operated by EG Australia) service stations across Australia, we're your one stop for
                food, coffee and fuel on the go! Available as an eGift Card only with no expiry date.
                """,
        cardTypeStatus: "AVAILABLE",
        disclaimer: "",
        customDenominations: []
    )
    
    static let ampolCard = GiftCard(
        vendor: "Eonx",
        id: "f8c8ac6a-a631-4a4e-a911-d9d5a1e2961f",
        brand: "EG Ampol Digital",
        image: "https://ucarecdn.com/715dd4fc-9fe0-46c5-ab61-54fc6a49d5ef/",
        denominations: [],
        position: 4,
        merchantId: "66515",
        terms: """
                <div>Woolworths Group Ltd ABN 88 000 014 675 is the issuer of the EG eGift Card.
                EG eGift Cards have no expiry date and are redeemable at participating stores only.
                Not redeemable at Ampol or Ampol Woolworths MetroGo co-branded outlets.</div>
                """,
        isFixedValue: false,
        importantContent: """
                <div>You can redeem this Gift Card in store at participating EG Ampol fuel sites.<br><br></div>
                <div>Redeem an eGift Card in store:<br>Select 'Card' as a payment method<br>
                Scan the barcode or enter the eGift Card number (also called in store code)<br><br></div>
                """,
        cardTypeStatus: "UNAVAILABLE",
        disclaimer: "",
        customDenominations: []
    )
    
    
    static let colesCard = GiftCard(
        vendor: "DigitalGlue",
        id: "AUCLSGFC003",
        brand: "Coles",
        image: "https://d2gktdeiupfo4o.cloudfront.net/images/deis/products/Coles.png",
        denominations: [
            Denomination(price: 5, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 10, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 20, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 30, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 50, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 100, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 150, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 200, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 250, currency: "AUD", stock: "IN_STOCK"),
            Denomination(price: 500, currency: "AUD", stock: "IN_STOCK")
        ],
        position: 8,
        merchantId: "66202",
        terms: """
            <div>Coles Group Limited (ABN 11 004 089 936) is the issuer of this eGift Card.</div>
            <ol>
                <li>This eGift Card can be redeemed at participating Coles Supermarkets, Coles Express 
                and Coles Online.</li>
                <li>Valid at participating stores across Australia only.</li>
                <li>This eGift Card cannot be redeemed for cash or used for online purchases at 
                Coles Express or Coles Liquor.</li>
                <li>Lost or stolen cards will not be replaced or refunded.</li>
                <li>For full terms and conditions, visit <a href="https://www.giftcards.com.au/coles">www.giftcards.com.au/coles</a></li>
                <li>Balance enquiries: call 1800 061 562</li>
            </ol>
            """,
        isFixedValue: false,
        importantContent: """
            <div>Your Coles eGift Card is ready to use at thousands of locations across Australia.</div>
            <h4>How to use your eGift Card:</h4>
            <ol>
                <li>For in-store purchases:
                    <ul>
                        <li>Present your eGift Card at the checkout</li>
                        <li>The cashier will scan the barcode</li>
                    </ul>
                </li>
                <li>For Coles Online:
                    <ul>
                        <li>Enter your eGift Card number during checkout</li>
                        <li>Your balance will be applied to your order</li>
                    </ul>
                </li>
            </ol>
            <p>Please note: This card cannot be used at Coles Express or Coles Liquor online.</p>
            """,
        cardTypeStatus: "AVAILABLE",
        disclaimer: "Card cannot be used for online purchases at Coles Express or Coles Liquor.",
        customDenominations: [
            CustomDenomination(minPrice: 5, maxPrice: 500)
        ]
    )
}
