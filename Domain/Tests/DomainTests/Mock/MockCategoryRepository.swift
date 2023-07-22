import Foundation
import Domain

final class MockCategoryRepository: Repository {
        
    var categories: Set<Domain.Category> = .init()
    
    func all(forceRefresh: Bool) async throws -> Set<Domain.Category> {
        categories
    }
    
    func item(for id: Int64) async -> Domain.Category? {
        categories.first(where: { $0.id == id })
    }
}
