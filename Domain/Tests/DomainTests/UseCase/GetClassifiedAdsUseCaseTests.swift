//
//  GetClassifiedAdsUseCaseTests.swift
//  
//
//  Created by Nicolás García on 21/07/2023.
//

import XCTest
@testable import Domain

final class GetClassifiedAdsUseCaseTests: XCTestCase {
    
    var sut: GetSortedClassifiedAdsUseCase!
    
    var categoryRepository: MockCategoryRepository!
    
    var classifiedAdRepository: MockClassifiedAdRepository!
    
    override func setUp() {
        super.setUp()
        categoryRepository = MockCategoryRepository()
        classifiedAdRepository = MockClassifiedAdRepository()
        sut = GetSortedClassifiedAdsUseCase(
            categoryRepository: categoryRepository,
            classifiedAdRepository: classifiedAdRepository
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
    
    func testGetAllClassifiedAdsSortedNonUrgent() async throws {
        // Given
        let itemA = ClassifiedAd(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemB = ClassifiedAd(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemC = ClassifiedAd(id: 2, title: "", categoryId: 2, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemD = ClassifiedAd(id: 3, title: "", categoryId: 3, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        classifiedAdRepository.items = [itemA, itemB, itemC, itemD]
        
        // When
        let result = try await sut(categoryId: nil, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result.map { $0.classifiedAd }, [itemD, itemC, itemB, itemA])
        XCTAssertEqual(result.map { $0.category?.id }, [itemD.categoryId, itemC.categoryId, itemB.categoryId, itemA.categoryId])
    }
    
    func testGetAllClassifiedAdsSortedSomeUrgent() async throws {
        // Given
        let itemA = ClassifiedAd(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemB = ClassifiedAd(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemC = ClassifiedAd(id: 2, title: "", categoryId: 2, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemD = ClassifiedAd(id: 3, title: "", categoryId: 3, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        classifiedAdRepository.items = [itemA, itemB, itemC, itemD]

        // When
        let result = try await sut(categoryId: nil, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result.map { $0.classifiedAd }, [itemB, itemA, itemD, itemC])
        XCTAssertEqual(result.map { $0.category?.id }, [itemB.categoryId, itemA.categoryId, itemD.categoryId, itemC.categoryId])
    }
    
    func testGetAllClassifiedAdsSortedAllUrgent() async throws {
        // Given
        let itemA = ClassifiedAd(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemB = ClassifiedAd(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemC = ClassifiedAd(id: 2, title: "", categoryId: 2, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemD = ClassifiedAd(id: 3, title: "", categoryId: 3, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        classifiedAdRepository.items = [itemA, itemB, itemC, itemD]

        // When
        let result = try await sut(categoryId: nil, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result.map { $0.classifiedAd }, [itemD, itemC, itemB, itemA])
        XCTAssertEqual(result.map { $0.category?.id }, [itemD.categoryId, itemC.categoryId, itemB.categoryId, itemA.categoryId])
    }
    
    // MARK: - filtered items by category
    
    func testGetFilteredClassifiedAdsSortedNonUrgent() async throws {
        // Given
        let itemA = ClassifiedAd(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemB = ClassifiedAd(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemC = ClassifiedAd(id: 2, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemD = ClassifiedAd(id: 3, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        classifiedAdRepository.items = [itemA, itemB, itemC, itemD]
        
        // When
        let result = try await sut(categoryId: 0, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result.map { $0.classifiedAd }, [itemC, itemA])
        XCTAssertEqual(result.map { $0.category?.id }, [itemC.categoryId, itemA.categoryId])
    }
    
    func testGetFilteredClassifiedAdsSortedSomeUrgent() async throws {
        // Given
        let itemA = ClassifiedAd(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemB = ClassifiedAd(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemC = ClassifiedAd(id: 2, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        let itemD = ClassifiedAd(id: 3, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        classifiedAdRepository.items = [itemA, itemB, itemC, itemD]

        // When
        let result = try await sut(categoryId: 0, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result.map { $0.classifiedAd }, [itemA, itemC])
        XCTAssertEqual(result.map { $0.category?.id }, [itemA.categoryId, itemC.categoryId])
    }
    
    func testGetFilteredClassifiedAdsSortedAllUrgent() async throws {
        // Given
        let itemA = ClassifiedAd(id: 0, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemB = ClassifiedAd(id: 1, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975030), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemC = ClassifiedAd(id: 2, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975031), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        let itemD = ClassifiedAd(id: 3, title: "", categoryId: 1, creationDate: Date(timeIntervalSince1970: 1689975032), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        classifiedAdRepository.items = [itemA, itemB, itemC, itemD]

        // When
        let result = try await sut(categoryId: 0, forceRefresh: Bool.random())
        
        // Then
        XCTAssertEqual(result.map { $0.classifiedAd }, [itemC, itemA])
        XCTAssertEqual(result.map { $0.category?.id }, [itemC.categoryId, itemA.categoryId])
    }
}
