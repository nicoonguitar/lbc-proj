import Foundation
import Domain

final class ClassifiedAdRepositoryImpl: ClassifiedAdRepository {
    
    private let apiClient: APIClient

    private let inMemoryCache: any InMemoryCache<ClassifiedAd>

    init(
        apiClient: APIClient,
        inMemoryCache: any InMemoryCache<ClassifiedAd>
    ) {
        self.apiClient = apiClient
        self.inMemoryCache = inMemoryCache
    }
    
    func all(forceRefresh: Bool) async throws -> Set<Domain.ClassifiedAd> {
        let cached = await inMemoryCache.cache
        if cached.isEmpty || forceRefresh {
            let response = try await apiClient.items()
            let models = response.compactMap { Domain.ClassifiedAd.build(from: $0) }
            await inMemoryCache.clean()
            await inMemoryCache.save(models)
            return await inMemoryCache.cache
        } else {
            return cached
        }
    }
    
    func item(for id: Int64) async -> Domain.ClassifiedAd? {
        await inMemoryCache.cache
            .first(where: { $0.id == id })
    }
}
