import Foundation

public struct GetItemsUseCase {
    private let itemRepository: any Repository<Item>
    
    init(itemRepository: any Repository<Item>) {
        self.itemRepository = itemRepository
    }
    
    public func callAsFunction(
        categoryId: Int64?,
        forceRefresh: Bool
    ) async throws -> [Item] {
        var items = try await itemRepository.all(forceRefresh: forceRefresh)
        if let categoryId {
            items = items.filter { $0.categoryId == categoryId }
        }
        return items.sorted(by: < )
    }
}
