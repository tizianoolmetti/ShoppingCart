//
//  DIContainer.swift
//  CandidateTest
//
//  Created by Tom Olmetti on 15/11/2024.
//

import Foundation
import SwiftUI
import Swinject

open class DIContainer {
    static var shared: DIContainer = .init()
    
    private var _container: Container?
    
    var container: Container {
        get {
            if _container == nil {
                _container = buildContainer()
            }
            
            return _container!
        }
        
        set {
            _container = newValue
        }
    }
    
    init() {
        registerViewModels()
        registerUseCases()
        registerRepositories()
        registerDataSources()
        registerManagers()
    }
    
    func buildContainer() -> Container {
        return Container()
    }
    
    static func makeContainer() {
        shared = DIContainer()
    }
    
    static func resolve<T>(_ type: T.Type, name: String? = nil) -> T {
        guard let component = shared.container.resolve(type, name: name) else { fatalError("\(T.self) is null") }
        return component
    }
}
