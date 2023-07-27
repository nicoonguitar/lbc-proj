import Foundation

/// The GetCategoriesUseCase class is responsible for fetching the available categories for classified ads.
/// It interacts with the CategoryRepository to retrieve the data and provides a method to execute the use case.
public final class GetCategoriesUseCase {
    
    private let categoryRepository: any CategoryRepository
    
    init(categoryRepository: any CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    /// Executes the use case to fetch the available categories for classified ads.
    ///
    /// Parameters:
    /// * forceRefresh: A boolean flag indicating whether to force a refresh of data from the backend even if it exists in the cache.
    ///
    /// Returns: An array of Category objects representing the available categories.
    /// Throws: An error if the use case encounters any issues during the fetching process.
    public func callAsFunction(
        forceRefresh: Bool
    ) async throws -> [Category] {
        try await categoryRepository.all(forceRefresh: forceRefresh)
        // Assumption: we sort ASC the categories by ID
            .sorted(by: { $0.id < $1.id })
    }
}
