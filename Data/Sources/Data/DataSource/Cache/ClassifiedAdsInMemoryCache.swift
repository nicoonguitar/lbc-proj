import Foundation
import Domain

actor ClassifiedAdsInMemoryCache: InMemoryCache {
    
    static let shared = ClassifiedAdsInMemoryCache()
    
    // Note: on a larger project, it may be appropiate to use instead a NSCache instance, so the system
    // will be able to unload the cached data in case its size grows to large in memory.
    private(set) var cache: Set<Domain.ClassifiedAd> = .init()
    
    func save(_ items: [Domain.ClassifiedAd]) async {
        cache = Set(items).union(cache)
    }
    
    func clean() async {
        cache.removeAll()
    }
}
