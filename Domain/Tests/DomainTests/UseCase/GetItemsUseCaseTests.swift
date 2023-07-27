//
//  GetItemsUseCaseTests.swift
//  
//
//  Created by Nicolás García on 21/07/2023.
//

import XCTest
@testable import Domain

final class GetItemsUseCaseTests: XCTestCase {
    
    var sut: GetSortedItemsUseCase!
    
    var categoryRepository: MockCategoryRepository!
    
    var itemRepository: MockItemRepository!
    
    override func setUp() {
        super.setUp()
        categoryRepository = MockCategoryRepository()
        itemRepository = MockItemRepository()
        sut = GetSortedItemsUseCase(
            categoryRepository: categoryRepository,
            itemRepository: itemRepository
        )
        
        // Populates categories dumb data
        categoryRepository.categories = [
            Category(id: 0, name: ""),
            Category(id: 1, name: ""),
            Category(id: 2, name: ""),
            Category(id: 3, name: "")
        ]
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
        XCTAssertEqual(result.map { $0.item }, [itemD, itemC, itemB, itemA])
        XCTAssertEqual(result.map { $0.category?.id }, [itemD.categoryId, itemC.categoryId, itemB.categoryId, itemA.categoryId])
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
        XCTAssertEqual(result.map { $0.item }, [itemB, itemA, itemD, itemC])
        XCTAssertEqual(result.map { $0.category?.id }, [itemB.categoryId, itemA.categoryId, itemD.categoryId, itemC.categoryId])
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
        XCTAssertEqual(result.map { $0.item }, [itemD, itemC, itemB, itemA])
        XCTAssertEqual(result.map { $0.category?.id }, [itemD.categoryId, itemC.categoryId, itemB.categoryId, itemA.categoryId])
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
        XCTAssertEqual(result.map { $0.item }, [itemC, itemA])
        XCTAssertEqual(result.map { $0.category?.id }, [itemC.categoryId, itemA.categoryId])
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
        XCTAssertEqual(result.map { $0.item }, [itemA, itemC])
        XCTAssertEqual(result.map { $0.category?.id }, [itemA.categoryId, itemC.categoryId])
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
        XCTAssertEqual(result.map { $0.item }, [itemC, itemA])
        XCTAssertEqual(result.map { $0.category?.id }, [itemC.categoryId, itemA.categoryId])
    }
}
