//
//  MockNetworkService.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

final class MockNetworkService: NetworkServiceProtocol {
    
    // MARK: Properties
    private var responseData: [String: Data] = [:]
    private var responseError: [String: Error] = [:]
    private(set) var requestedEndpoints: [APIEndpoint] = []
    
    // MARK: Methods
    func addResponse(for endpoint: APIEndpoint, data: Data) {
        responseData[endpoint.path] = data
    }
    
    func addError(for endpoint: APIEndpoint, error: Error) {
        responseError[endpoint.path] = error
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        requestedEndpoints.append(endpoint)
        
        if let error = responseError[endpoint.path] {
            throw error
        }
        
        guard let data = responseData[endpoint.path] else {
            throw NetworkError.invalidResponse
        }
        
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
}
