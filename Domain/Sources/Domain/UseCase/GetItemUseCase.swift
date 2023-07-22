import Foundation

public struct GetItemUseCase {
    private let itemRepository: any Repository<Item>
    
    init(itemRepository: any Repository<Item>) {
        self.itemRepository = itemRepository
    }
    
    public func callAsFunction(
        itemId: Int64
    ) async -> Item? {
        await itemRepository.item(for: itemId)
    }
}
