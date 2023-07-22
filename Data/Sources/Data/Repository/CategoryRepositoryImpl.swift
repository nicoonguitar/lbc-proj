import Foundation
import Domain

final class CategoryRepositoryImpl: Repository {
        
    private let apiClient: APIClient
    
    private let inMemoryCache: any InMemoryCache<Domain.Category>
    
    init(
        apiClient: APIClient,
        inMemoryCache: any InMemoryCache<Domain.Category> = CategoryInMemoryCache.shared
    ) {
        self.apiClient = apiClient
        self.inMemoryCache = inMemoryCache
    }
    
    func all(forceRefresh: Bool) async throws -> Set<Domain.Category> {
        let cached = await inMemoryCache.cache
        if cached.isEmpty || forceRefresh {
            let response = try await apiClient.categories()
            let models = response.map { Domain.Category.build(from: $0) }
            await inMemoryCache.clean()
            await inMemoryCache.save(models)
            return await inMemoryCache.cache
        } else {
            return cached
        }
    }
    
    func item(for id: Int64) async -> Domain.Category? {
        await inMemoryCache.cache
            .first(where: { $0.id == id })
    }
}
