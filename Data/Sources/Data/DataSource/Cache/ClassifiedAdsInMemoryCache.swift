import Foundation
import Domain

actor ClassifiedAdsInMemoryCache: InMemoryCache {
    
    static let shared = ClassifiedAdsInMemoryCache()
    
    private(set) var cache: Set<Domain.ClassifiedAd> = .init()
    
    func save(_ items: [Domain.ClassifiedAd]) async {
        cache = Set(items).union(cache)
    }
    
    func clean() async {
        cache.removeAll()
    }
}
