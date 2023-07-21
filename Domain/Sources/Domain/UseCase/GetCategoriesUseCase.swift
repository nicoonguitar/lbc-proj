import Foundation

public final class GetCategoriesUseCase {
    private let categoryRepository: CategoryRepository
    
    init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    public func callAsFunction(
        forceRefresh: Bool
    ) async throws -> [Category] {
        try await categoryRepository.all(forceRefresh: forceRefresh)
        // Q: should apply sorting by ID asc ?
    }
}
