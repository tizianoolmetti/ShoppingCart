//
//  DIContainer+Manager.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation

extension DIContainer {
    func registerManagers() {
        container.register(NetworkService.self) { _ in
            NetworkService()
        }
    }
}
