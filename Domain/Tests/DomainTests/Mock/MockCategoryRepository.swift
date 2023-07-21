import Foundation
import Domain

final class MockCategoryRepository: CategoryRepository {
    
    var categories: [Domain.Category] = []
    
    func all(forceRefresh: Bool) async throws -> [Domain.Category] {
        categories
    }
}
