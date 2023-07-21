import XCTest
@testable import Domain

final class GetCategoriesUseCaseTests: XCTestCase {

    var sut: GetCategoriesUseCase!
    
    var categoryRepository: MockCategoryRepository!
    
    override func setUpWithError() throws {
        categoryRepository = MockCategoryRepository()
        sut = GetCategoriesUseCase(
            categoryRepository: categoryRepository
        )
    }

    func testGetAllNoResults() async throws {
        // Given
        XCTAssert(categoryRepository.categories.isEmpty)
        
        // When
        let result = try await categoryRepository.all(forceRefresh: Bool.random())
        
        // Then
        XCTAssert(result.isEmpty)
    }
    
    func testGetAll() async throws {
        // Given
        let catA = Category(id: 0, name: "")
        let catB = Category(id: 1, name: "")
        let catC = Category(id: 2, name: "")
        categoryRepository.categories = [catA, catB, catC]
        
        // When
        let result = try await categoryRepository.all(forceRefresh: Bool.random())

        // Then
        XCTAssertEqual(result, [catA, catB, catC])
    }
}
