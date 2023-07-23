import Foundation

public protocol Repository<T>: AnyObject where T: Hashable {
    associatedtype T
    
    func all(
        forceRefresh: Bool
    ) async throws -> Set<T>
    
    func item(for id: Int64) async -> T?
}

/*
 Because of having a min deployment version iOS 14 we need to define conforming protocols for each Repository type
 because runtime support for parameterized protocol types is only available in iOS 16.0.0 or newer.
 */
public protocol CategoryRepository: Repository<Category> {}

public protocol ItemRepository: Repository<Item> {}
