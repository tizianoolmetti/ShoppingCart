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
        .kmartCard,
        .woolworthsCard,
        .uberEatsCard
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
}
