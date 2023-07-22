import Foundation
import Domain

@globalActor
actor ItemsInMemoryCache: InMemoryCache {
    
    static let shared = ItemsInMemoryCache()
    
    private(set) var cache: Set<Domain.Item> = .init()
    
    func save(_ items: [Domain.Item]) async {
        cache = Set(items).union(cache)
    }
    
    func clean() async {
        cache.removeAll()
    }
}
