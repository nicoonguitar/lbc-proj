//
//  GetItemsUseCaseTests.swift
//  
//
//  Created by Nicolás García on 21/07/2023.
//

import XCTest
@testable import Domain

final class GetItemsUseCaseTests: XCTestCase {

    var sut: GetItemsUseCase!
    
    var itemRepository: MockItemRepository!
    
    override func setUp() {
        super.setUp()
        itemRepository = MockItemRepository()
        sut = GetItemsUseCase(
            itemRepository: itemRepository
        )
    }

    // MARK: - all items
    
    func testGetAllItemsSortedNonUrgent() async throws {
        // Given
        let itemA = Item(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemB = Item(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemC = Item(id: 2, title: "", categoryId: 2, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemD = Item(id: 3, title: "", categoryId: 3, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        itemRepository.items = [itemA, itemB, itemC, itemD]
        
        // When
        let result = try await sut(categoryId: nil, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result, [itemD, itemC, itemB, itemA])
    }
    
    func testGetAllItemsSortedSomeUrgent() async throws {
        // Given
        let itemA = Item(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemB = Item(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemC = Item(id: 2, title: "", categoryId: 2, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemD = Item(id: 3, title: "", categoryId: 3, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        itemRepository.items = [itemA, itemB, itemC, itemD]

        // When
        let result = try await sut(categoryId: nil, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result, [itemB, itemA, itemD, itemC])
    }
    
    func testGetAllItemsSortedAllUrgent() async throws {
        // Given
        let itemA = Item(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemB = Item(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemC = Item(id: 2, title: "", categoryId: 2, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemD = Item(id: 3, title: "", categoryId: 3, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        itemRepository.items = [itemA, itemB, itemC, itemD]

        // When
        let result = try await sut(categoryId: nil, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result, [itemD, itemC, itemB, itemA])
    }
    
    // MARK: - filtered items by category
    
    func testGetFilteredItemsSortedNonUrgent() async throws {
        // Given
        let itemA = Item(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemB = Item(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemC = Item(id: 2, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemD = Item(id: 3, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        itemRepository.items = [itemA, itemB, itemC, itemD]
        
        // When
        let result = try await sut(categoryId: 0, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result, [itemC, itemA])
    }
    
    func testGetFilteredItemsSortedSomeUrgent() async throws {
        // Given
        let itemA = Item(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemB = Item(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemC = Item(id: 2, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemD = Item(id: 3, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        itemRepository.items = [itemA, itemB, itemC, itemD]

        // When
        let result = try await sut(categoryId: 0, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result, [itemA, itemC])
    }
    
    func testGetFilteredItemsSortedAllUrgent() async throws {
        // Given
        let itemA = Item(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemB = Item(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemC = Item(id: 2, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemD = Item(id: 3, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        itemRepository.items = [itemA, itemB, itemC, itemD]

        // When
        let result = try await sut(categoryId: 0, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result, [itemC, itemA])
    }
}
