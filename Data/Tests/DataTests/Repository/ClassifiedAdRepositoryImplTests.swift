import XCTest
@testable import Data
import Domain

final class ClassifiedAdRepositoryImplTests: XCTestCase {

    var sut: ClassifiedAdRepositoryImpl!
    
    var apiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        sut = ClassifiedAdRepositoryImpl(
            apiClient: apiClient,
            inMemoryCache: ClassifiedAdsInMemoryCache.shared
        )
    }
    
    override func tearDown() {
        super.tearDown()
        apiClient.items.removeAll()
    }
    
    private func loadItemsJSON() async throws -> [ApiClassifiedAd] {
        let url  = try XCTUnwrap(
            Bundle.module.url(
                forResource: "listing",
                withExtension: "json"
            )
        )
        let jsonData = try Data(contentsOf: url)
        return try JSONDecoder().decode([ApiClassifiedAd].self, from: jsonData)
    }
    
    // MARK: - get all items
    
    func testGetAllByForcingRefresh() async throws {
        // Given
        apiClient.items = try await loadItemsJSON()
        
        await ClassifiedAdsInMemoryCache.shared.save([
            .init(id: 0, title: "", categoryId: 0, creationDate: Date(), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: true, price: 0, siret: nil)
        ])
        let cacheCount = await ClassifiedAdsInMemoryCache.shared.cache.count
        XCTAssertEqual(cacheCount, 1)
        
        // When
        let result = try await sut.all(forceRefresh: true)
        
        // Then
        XCTAssertEqual(result.count, apiClient.items.count)

        addTeardownBlock {
            await ClassifiedAdsInMemoryCache.shared.clean()
        }
    }
    
    func testGetAllForcesRefreshIfCacheIsEmpty() async throws {
        // Given
        apiClient.items = try await loadItemsJSON()

        let cacheCount = await ClassifiedAdsInMemoryCache.shared.cache.count
        XCTAssertEqual(cacheCount, 0)
        
        // When
        let result = try await sut.all(forceRefresh: false)
        
        // Then
        XCTAssertEqual(result.count, apiClient.items.count)

        addTeardownBlock {
            await ClassifiedAdsInMemoryCache.shared.clean()
        }
    }
    
    func testGetAllReturnsCachedDataIfAnyAndRefreshIsNotForced() async throws {
        // Given
        let cached = try await loadItemsJSON()
            .compactMap { Domain.ClassifiedAd.build(from: $0) }
        await ClassifiedAdsInMemoryCache.shared.save(cached)
        
        XCTAssert(apiClient.items.isEmpty)
        
        // When
        let result = try await sut.all(forceRefresh: false)
        
        // Then
        let cacheCount = await ClassifiedAdsInMemoryCache.shared.cache.count
        XCTAssertEqual(result.count, cacheCount)

        addTeardownBlock {
            await ClassifiedAdsInMemoryCache.shared.clean()
        }
    }
    
    // MARK: - get item by id
    
    func testGetClassifiedAdExists() async throws {
        // Given
        let cached = try await loadItemsJSON()
            .compactMap { Domain.ClassifiedAd.build(from: $0) }
        await ClassifiedAdsInMemoryCache.shared.save(cached)
        
        // When
        let id: Int64 = 1461267313
        let result = await sut.item(for: id)
        
        // Then
        XCTAssertEqual(try XCTUnwrap(result).id, id)
        
        addTeardownBlock {
            await ClassifiedAdsInMemoryCache.shared.clean()
        }
    }
    
    func testGetClassifiedAdDoesNotExist() async throws {
        // Given
        let cached = try await loadItemsJSON()
            .compactMap { Domain.ClassifiedAd.build(from: $0) }
        await ClassifiedAdsInMemoryCache.shared.save(cached)
        
        // When
        let id: Int64 = 0
        let result = await sut.item(for: id)
        
        // Then
        XCTAssertNil(result)
        
        addTeardownBlock {
            await ClassifiedAdsInMemoryCache.shared.clean()
        }
    }
}
