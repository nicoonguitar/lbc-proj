import Foundation
import Domain

final class MockItemRepository: ItemRepository {
    
    var items: Set<Domain.Item> = .init()
    
    func all(forceRefresh: Bool) async throws -> Set<Domain.Item> {
        items
    }
    
    func item(for id: Int64) -> Domain.Item? {
        items.first(where: { $0.id == id })
    }
}
