import Foundation

/// The GetSortedItemsUseCase is a  responsible for fetching the listing of classified ads and their associated categories.
/// It interacts with the CategoryRepository and ItemRepository to retrieve the data and provides a method to execute the use case.
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
    
    /// Executes the use case to fetch the listing of classified ads and their associated categories.
    /// The method provides an option to filter the items by a specific category ID and sorts them based on
    /// two criteria: isUrgent and the creation date property in descending order.
    /// - Parameters:
    ///   - categoryId: An optional parameter representing the category ID to filter the items. If nil, all items are returned without filtering by category.
    ///   - forceRefresh: A boolean flag indicating whether to force a refresh of data from the backend even if it exists in the cache.
    /// - Returns: An array of tuples, where each tuple contains a classified ad Item and an optional associated Category. The array is sorted in the following order:
    /// Classified ads with isUrgent set to true are placed at the beginning of the array.
    /// The remaining classified ads are sorted based on the date property in descending order (newest to oldest).
    /// - Throws: An error if the use case encounters any issues during the fetching process.
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
