import Foundation

/// The GetClassifiedAdUseCase is responsible for fetching a classified ad by its ID and its associated category.
/// It interacts with the CategoryRepository and ClassifiedAdRepository to retrieve the data and provides a method to execute the use case.
public struct GetClassifiedAdUseCase {
    private let categoryRepository: any CategoryRepository
    
    private let classifiedAdRepository: any ClassifiedAdRepository
    
    init(
        categoryRepository: any CategoryRepository,
        classifiedAdRepository: any ClassifiedAdRepository
    ) {
        self.categoryRepository = categoryRepository
        self.classifiedAdRepository = classifiedAdRepository
    }
    
    /// Executes the use case to fetch a classified ad and its associated category by its ID.
    ///
    /// - Parameter itemId: The unique identifier of the classified ad to fetch.
    /// - Returns: A tuple containing the fetched Item and an optional Category. If the Item with the specified itemId is not found, it returns nil.
    ///
    /// Note: Not finding data for a given category ID is an undefined behaviour, as there isn't a service to fetch data in the provided API.
    public func callAsFunction(
        itemId: Int64
    ) async -> (item: ClassifiedAd, category: Category?)? {
        guard let item = await classifiedAdRepository.item(for: itemId) else {
            return nil
        }
        let category = await categoryRepository.item(for: item.categoryId)
        return (item, category)
    }
}
