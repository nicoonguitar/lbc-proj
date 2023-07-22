import Foundation

public protocol Repository<T>: AnyObject where T: Hashable {
    associatedtype T
    
    func all(
        forceRefresh: Bool
    ) async throws -> Set<T>
    
    func item(for id: Int64) async -> T?
}

