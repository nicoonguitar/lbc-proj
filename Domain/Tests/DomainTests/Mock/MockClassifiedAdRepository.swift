import Foundation
import Domain

final class MockClassifiedAdRepository: ClassifiedAdRepository {
    
    var items: Set<Domain.ClassifiedAd> = .init()
    
    func all(forceRefresh: Bool) async throws -> Set<Domain.ClassifiedAd> {
        items
    }
    
    func item(for id: Int64) -> Domain.ClassifiedAd? {
        items.first(where: { $0.id == id })
    }
}
