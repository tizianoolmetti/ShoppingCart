//
//  GiftCardsEndpoint.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import Foundation

enum GiftCardsEndpoint: APIEndpoint {
    case list
    case detail(id: String)
    
    var scheme: String { "https" }
    var host: String { "zip.co" }
    
    var path: String {
        switch self {
        case .list:
            return "/giftcards/api/giftcards"
        case .detail(let id):
            return "/giftcards/api/giftcards/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .detail:
            return .get
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
