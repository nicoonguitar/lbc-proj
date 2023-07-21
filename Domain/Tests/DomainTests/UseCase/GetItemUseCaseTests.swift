import XCTest
@testable import Domain

final class GetItemUseCaseTests: XCTestCase {

    var sut: GetItemUseCase!
    
    var itemRepository: MockItemRepository!

    override func setUp() {
        super.setUp()
        itemRepository = MockItemRepository()
        sut = GetItemUseCase(
            itemRepository: itemRepository
        )
    }

    func testGetItemExists() {
        // Given
        let itemId: Int64 = 0
        let itemA = Item(id: itemId, title: "", categoryId: 0, creationDate: Date(timeIntervalSince1970: 1689975029), description: "", imagesURL: .init(small: nil, thumb: nil), isUrgent: false, price: 0, siret: nil)
        itemRepository.items = [itemA]
        
        // When
        let result = sut(itemId: itemId)
        
        // Then
        XCTAssertEqual(result, itemA)
    }

    func testGetItemDoesNotExist() {
        // Given
        XCTAssert(itemRepository.items.isEmpty)
        let itemId: Int64 = 0

        // When
        let result = sut(itemId: itemId)

        // Then
        XCTAssertNil(result)
    }
}
