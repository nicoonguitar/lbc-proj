import Foundation
import Domain

@globalActor
actor CategoryInMemoryCache: InMemoryCache {
    
    static let shared = CategoryInMemoryCache()
    
    private(set) var cache: Set<Domain.Category> = .init()
    
    func save(_ items: [Domain.Category]) {
        cache = Set(items).union(cache)
    }
    
    func clean() {
        cache.removeAll()
    }
}
