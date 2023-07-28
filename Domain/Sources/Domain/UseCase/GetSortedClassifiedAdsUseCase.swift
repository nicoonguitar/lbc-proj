import Foundation

/// The GetSortedClassifiedAdsUseCase is a  responsible for fetching the listing of classified ads and their associated categories.
/// It interacts with the CategoryRepository and ClassifiedAdRepository to retrieve the data and provides a method to execute the use case.
public struct GetSortedClassifiedAdsUseCase {
    
    private let categoryRepository: any CategoryRepository
    
    private let classifiedAdRepository: any ClassifiedAdRepository
    
    init(
        categoryRepository: any CategoryRepository,
        classifiedAdRepository: any ClassifiedAdRepository
    ) {
        self.categoryRepository = categoryRepository
        self.classifiedAdRepository = classifiedAdRepository
    }
    
    /// Executes the use case to fetch the listing of classified ads and their associated categories.
    /// The method provides an option to filter the classifiedAds by a specific category ID and sorts them based on
    /// two criteria: isUrgent and the creation date property in descending order.
    /// - Parameters:
    ///   - categoryId: An optional parameter representing the category ID to filter the classifiedAds. If nil, all classifiedAds are returned without filtering by category.
    ///   - forceRefresh: A boolean flag indicating whether to force a refresh of data from the backend even if it exists in the cache.
    /// - Returns: An array of tuples, where each tuple contains a classified ad Item and an optional associated Category. The array is sorted in the following order:
    /// Classified ads with isUrgent set to true are placed at the beginning of the array.
    /// The remaining classified ads are sorted based on the date property in descending order (newest to oldest).
    /// - Throws: An error if the use case encounters any issues during the fetching process.
    public func callAsFunction(
        categoryId: Int64?,
        forceRefresh: Bool
    ) async throws -> [(classifiedAd: ClassifiedAd, category: Category?)] {
        async let classifiedAds =  classifiedAdRepository.all(forceRefresh: forceRefresh)
        async let categories = categoryRepository.all(forceRefresh: false)
        let results = try await (classifiedAds: classifiedAds, categories: categories)

        if let categoryId,
           let category = results.categories.first(where: { $0.id == categoryId }) {
            return results.classifiedAds
                .filter { $0.categoryId == categoryId }
                .sorted(by: < )
                .map { ($0, category) }
        } else {
            return results.classifiedAds
                .sorted(by: < )
                .map { ad in
                    (ad, results.categories.first(where: { $0.id == ad.categoryId }))
                }
        }
    }
}
