import Foundation

public struct GetItemUseCase {
    private let itemRepository: any ItemRepository
    
    init(itemRepository: any ItemRepository) {
        self.itemRepository = itemRepository
    }
    
    public func callAsFunction(
        itemId: Int64
    ) async -> Item? {
        await itemRepository.item(for: itemId)
    }
}
