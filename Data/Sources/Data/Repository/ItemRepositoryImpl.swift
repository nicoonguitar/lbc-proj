import Foundation
import Domain

final class ItemRepositoryImpl: Repository {
    
    private let apiClient: APIClient

    private let inMemoryCache: any InMemoryCache<Item>

    init(
        apiClient: APIClient,
        inMemoryCache: any InMemoryCache<Item> = ItemsInMemoryCache.shared
    ) {
        self.apiClient = apiClient
        self.inMemoryCache = inMemoryCache
    }
    
    func all(forceRefresh: Bool) async throws -> Set<Domain.Item> {
        let cached = await inMemoryCache.cache
        if cached.isEmpty || forceRefresh {
            let response = try await apiClient.items()
            let models = response.map { Domain.Item.build(from: $0) }
            await inMemoryCache.clean()
            await inMemoryCache.save(models)
            return await inMemoryCache.cache
        } else {
            return cached
        }
    }
    
    func item(for id: Int64) async -> Domain.Item? {
        await inMemoryCache.cache
            .first(where: { $0.id == id })
    }
}
