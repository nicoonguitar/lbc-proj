//
//  DataAssemblyTests.swift
//  
//
//  Created by Nicolás García on 23/07/2023.
//

import XCTest
@testable import Data
import Domain
import ServiceLocator

final class DataAssemblyTests: XCTestCase {

    func testRegisteredRepositoryImplementations() {
        DataAssembly.register(serviceLocator: ServiceLocator.shared)
        let _: any CategoryRepository = ServiceLocator.shared.get()
        let _: any ClassifiedAdRepository = ServiceLocator.shared.get()
    }
}
