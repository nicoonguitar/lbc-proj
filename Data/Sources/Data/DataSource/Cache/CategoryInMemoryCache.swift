import Foundation
import Domain

actor CategoryInMemoryCache: InMemoryCache {
    
    static let shared = CategoryInMemoryCache()
    
    // Note: on a larger project, it may be appropiate to use instead a NSCache instance, so the system
    // will be able to unload the cached data in case its size grows to large in memory.
    private(set) var cache: Set<Domain.Category> = .init()
    
    func save(_ items: [Domain.Category]) {
        cache = Set(items).union(cache)
    }
    
    func clean() {
        cache.removeAll()
    }
}
