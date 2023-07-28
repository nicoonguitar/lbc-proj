import XCTest
@testable import Domain

final class GetClassifiedAdUseCaseTests: XCTestCase {

    var sut: GetClassifiedAdUseCase!
    
    var categoryRepository: MockCategoryRepository!

    var classifiedAdRepository: MockClassifiedAdRepository!

    override func setUp() {
        super.setUp()
        classifiedAdRepository = MockClassifiedAdRepository()
        categoryRepository = MockCategoryRepository()
        sut = GetClassifiedAdUseCase(
            categoryRepository: categoryRepository,
            classifiedAdRepository: classifiedAdRepository
        )
    }

    func testGetClassifiedAdExists() async {
        // Given
        let itemId: Int64 = 0
        let itemA = ClassifiedAd(id: itemId, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        classifiedAdRepository.items = [itemA]
        
        // When
        let result = await sut(itemId: itemId)
        
        // Then
        XCTAssertEqual(result.map { $0.item }, itemA)
    }

    func testGetClassifiedAdDoesNotExist() async {
        // Given
        XCTAssert(classifiedAdRepository.items.isEmpty)
        let itemId: Int64 = 0

        // When
        let result = await sut(itemId: itemId)

        // Then
        XCTAssertNil(result)
    }
}
