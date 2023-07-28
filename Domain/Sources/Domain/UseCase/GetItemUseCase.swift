import Foundation

/// The GetItemUseCase is responsible for fetching a classified ad by its ID and its associated category.
/// It interacts with the CategoryRepository and ItemRepository to retrieve the data and provides a method to execute the use case.
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
    
    /// Executes the use case to fetch a classified ad and its associated category by its ID.
    ///
    /// - Parameter itemId: The unique identifier of the classified ad to fetch.
    /// - Returns: A tuple containing the fetched Item and an optional Category. If the Item with the specified itemId is not found, it returns nil.
    ///
    /// Note: Not finding data for a given category ID is an undefined behaviour, as there isn't a service to fetch data in the provided API.
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
