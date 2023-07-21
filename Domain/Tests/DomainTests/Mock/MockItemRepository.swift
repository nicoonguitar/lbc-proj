import Foundation
import Domain

final class MockItemRepository: ItemRepository {
    
    var items: [Domain.Item] = []
    
    func all(forceRefresh: Bool) async throws -> [Domain.Item] {
        items
    }
    
    func item(for id: Int64) -> Domain.Item? {
        items.first(where: { $0.id == id })
    }
}
