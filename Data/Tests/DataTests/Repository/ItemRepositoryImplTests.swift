import XCTest
@testable import Data
import Domain

final class ItemRepositoryImplTests: XCTestCase {

    var sut: ItemRepositoryImpl!
    
    var apiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        sut = ItemRepositoryImpl(
            apiClient: apiClient,
            inMemoryCache: ItemsInMemoryCache.shared
        )
    }
    
    override func tearDown() {
        super.tearDown()
        apiClient.items.removeAll()
    }
    
    private func loadItemsJSON() async throws -> [ApiItem] {
        let url  = try XCTUnwrap(
            Bundle.module.url(
                forResource: "listing",
                withExtension: "json"
            )
        )
        let jsonData = try Data(contentsOf: url)
        return try JSONDecoder().decode([ApiItem].self, from: jsonData)
    }
    
    // MARK: - get all items
    
    func testGetAllByForcingRefresh() async throws {
        // Given
        apiClient.items = try await loadItemsJSON()
        
        await ItemsInMemoryCache.shared.save([
            .init(id: 0, title: "", categoryId: 0, creationDate: Date(), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        ])
        let cacheCount = await ItemsInMemoryCache.shared.cache.count
        XCTAssertEqual(cacheCount, 1)
        
        // When
        let result = try await sut.all(forceRefresh: true)
        
        // Then
        XCTAssertEqual(result.count, apiClient.items.count)

        addTeardownBlock {
            await ItemsInMemoryCache.shared.clean()
        }
    }
    
    func testGetAllForcesRefreshIfCacheIsEmpty() async throws {
        // Given
        apiClient.items = try await loadItemsJSON()

        let cacheCount = await ItemsInMemoryCache.shared.cache.count
        XCTAssertEqual(cacheCount, 0)
        
        // When
        let result = try await sut.all(forceRefresh: false)
        
        // Then
        XCTAssertEqual(result.count, apiClient.items.count)

        addTeardownBlock {
            await ItemsInMemoryCache.shared.clean()
        }
    }
    
    func testGetAllReturnsCachedDataIfAnyAndRefreshIsNotForced() async throws {
        // Given
        let cached = try await loadItemsJSON()
            .compactMap { Domain.Item.build(from: $0) }
        await ItemsInMemoryCache.shared.save(cached)
        
        XCTAssert(apiClient.items.isEmpty)
        
        // When
        let result = try await sut.all(forceRefresh: false)
        
        // Then
        let cacheCount = await ItemsInMemoryCache.shared.cache.count
        XCTAssertEqual(result.count, cacheCount)

        addTeardownBlock {
            await ItemsInMemoryCache.shared.clean()
        }
    }
    
    // MARK: - get item by id
    
    func testGetItemExists() async throws {
        // Given
        let cached = try await loadItemsJSON()
            .compactMap { Domain.Item.build(from: $0) }
        await ItemsInMemoryCache.shared.save(cached)
        
        // When
        let id: Int64 = 1461267313
        let result = await sut.item(for: id)
        
        // Then
        XCTAssertEqual(try XCTUnwrap(result).id, id)
        
        addTeardownBlock {
            await ItemsInMemoryCache.shared.clean()
        }
    }
    
    func testGetItemDoesNotExist() async throws {
        // Given
        let cached = try await loadItemsJSON()
            .compactMap { Domain.Item.build(from: $0) }
        await ItemsInMemoryCache.shared.save(cached)
        
        // When
        let id: Int64 = 0
        let result = await sut.item(for: id)
        
        // Then
        XCTAssertNil(result)
        
        addTeardownBlock {
            await ItemsInMemoryCache.shared.clean()
        }
    }
}
