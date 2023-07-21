import Foundation

public struct GetItemUseCase {
    private let itemRepository: ItemRepository
    
    init(itemRepository: ItemRepository) {
        self.itemRepository = itemRepository
    }
    
    public func callAsFunction(
        itemId: Int64
    ) -> Item? {
        itemRepository.item(for: itemId)
    }
}
