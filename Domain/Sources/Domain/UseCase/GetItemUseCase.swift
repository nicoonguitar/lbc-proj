import Foundation

/*
 This use case fetches a classified ads by ID and its associated category.
 It returns a tuple containing the Classified Ad and an optional Category instances.
 
 Note: Not finding data for a given category ID is an undefined behaviour.
 */
public struct GetItemUseCase {
    private let categoryRepository: any CategoryRepository
    
    private let itemRepository: any ItemRepository
    
    init(
        categoryRepository: any CategoryRepository,
        itemRepository: any ItemRepository
    ) {
        self.categoryRepository = categoryRepository
        self.itemRepository = itemRepository
    }
    
    public func callAsFunction(
        itemId: Int64
    ) async -> (item: Item, category: Category?)? {
        guard let item = await itemRepository.item(for: itemId) else {
            return nil
        }
        let category = await categoryRepository.item(for: item.categoryId)
        return (item, category)
    }
}
