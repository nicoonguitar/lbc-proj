import Foundation

public final class GetCategoriesUseCase {
    private let categoryRepository: any CategoryRepository
    
    init(categoryRepository: any CategoryRepository) {
        self.categoryRepository = categoryRepository
    }
    
    public func callAsFunction(
        forceRefresh: Bool
    ) async throws -> [Category] {
        try await categoryRepository.all(forceRefresh: forceRefresh)
        // Q: should apply sorting by ID asc ?
            .sorted(by: { $0.id < $1.id })
    }
}
