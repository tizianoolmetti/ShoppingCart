//
//  APIEndpoint.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 14/11/2024.
//

import Foundation

protocol APIEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}
