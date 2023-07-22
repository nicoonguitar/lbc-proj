import XCTest
@testable import Data
import Domain

final class CategoryRepositoryImplTests: XCTestCase {

    var sut: CategoryRepositoryImpl!
    
    var apiClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        sut = CategoryRepositoryImpl(
            apiClient: apiClient,
            inMemoryCache: CategoryInMemoryCache.shared
        )
    }
    
    override func tearDown() {
        super.tearDown()
        apiClient.categories.removeAll()
    }
    
    private func loadCategoriesJSON() async throws -> [ApiCategory] {
        let url  = try XCTUnwrap(
            Bundle.module.url(
                forResource: "categories",
                withExtension: "json"
            )
        )
        let jsonData = try Data(contentsOf: url)
        return try JSONDecoder().decode([ApiCategory].self, from: jsonData)
    }
    
    func testGetAllByForcingRefresh() async throws {
        // Given
        apiClient.categories = try await loadCategoriesJSON()
        
        await CategoryInMemoryCache.shared.save([
            .init(id: Int64(Int.random(in: 0...5)), name: UUID().uuidString)
        ])
        let cacheCount = await CategoryInMemoryCache.shared.cache.count
        XCTAssertEqual(cacheCount, 1)
        
        // When
        let result = try await sut.all(forceRefresh: true)
        
        // Then
        XCTAssertEqual(result.count, apiClient.categories.count)

        addTeardownBlock {
            await CategoryInMemoryCache.shared.clean()
        }
    }
    
    func testGetAllForcesRefreshIfCacheIsEmpty() async throws {
        // Given
        apiClient.categories = try await loadCategoriesJSON()

        let cacheCount = await CategoryInMemoryCache.shared.cache.count
        XCTAssertEqual(cacheCount, 0)
        
        // When
        let result = try await sut.all(forceRefresh: false)
        
        // Then
        XCTAssertEqual(result.count, apiClient.categories.count)

        addTeardownBlock {
            await CategoryInMemoryCache.shared.clean()
        }
    }
    
    func testGetAllReturnsCachedDataIfAnyAndRefreshIsNotForced() async throws {
        // Given
        let cached = try await loadCategoriesJSON()
            .map { Domain.Category.build(from: $0) }
        await CategoryInMemoryCache.shared.save(cached)
        
        XCTAssert(apiClient.categories.isEmpty)
        
        // When
        let result = try await sut.all(forceRefresh: false)
        
        // Then
        let cacheCount = await CategoryInMemoryCache.shared.cache.count
        XCTAssertEqual(result.count, cacheCount)

        addTeardownBlock {
            await CategoryInMemoryCache.shared.clean()
        }
    }
}
