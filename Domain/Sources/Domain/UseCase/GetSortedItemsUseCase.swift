import Foundation

/*
 This use case fetches the listing of classified ads and their associated category.
 It returns an sorted array of tuples containing each a Classified Ad and an optional Category.
 
 Note: Not finding data for a given category ID is an undefined behaviour.
 */
public struct GetSortedItemsUseCase {
    
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
        categoryId: Int64?,
        forceRefresh: Bool
    ) async throws -> [(item: Item, category: Category?)] {
        async let items =  itemRepository.all(forceRefresh: forceRefresh)
        async let categories = categoryRepository.all(forceRefresh: false)
        let results = try await (items: items, categories: categories)

        if let categoryId,
           let category = results.categories.first(where: { $0.id == categoryId }) {
            return results.items
                .filter { $0.categoryId == categoryId }
                .sorted(by: < )
                .map { ($0, category) }
        } else {
            return results.items
                .sorted(by: < )
                .map { item in
                    (item, results.categories.first(where: { $0.id == item.categoryId }))
                }
        }
    }
}
