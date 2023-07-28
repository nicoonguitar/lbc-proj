import Foundation

/// The Repository protocol is a Swift protocol designed to define the common interface for repositories that manage data of a generic type T.
/// It requires conforming types to implement methods for fetching all items and a specific item based on its ID.
public protocol Repository<T>: AnyObject where T: Hashable {
    associatedtype T
    
    /// Fetches all items of type T from the repository. The method provides an option to force a refresh of data from the backend, bypassing any cached data.
    /// - Parameter forceRefresh: A boolean flag indicating whether to force a refresh of data from the backend even if it exists in the cache.
    /// - Returns: An asynchronous set of items (Set<T>) representing all the fetched elements of type T.
    /// - Throws: An error if the repository encounters any issues during the fetching process.
    func all(
        forceRefresh: Bool
    ) async throws -> Set<T>
    
    /// Fetches an item of type T from the repository based on its unique identifier, which is represented by the id parameter.
    /// - Parameter id: The unique identifier of the item to fetch.
    /// - Returns: An asynchronous optional item of type T, which is the fetched element with the specified id. If no item is found for the given id, it returns nil.
    ///
    /// Note: the function doesn't allow to force refresh as there isn't an API to fetch individual items.
    func item(for id: Int64) async -> T?
}

/*
 Because of having a min deployment version iOS 14 we need to define conforming protocols for each Repository type
 because runtime support for parameterized protocol types is only available in iOS 16.0.0 or newer.
 */
public protocol CategoryRepository: Repository<Category> {}

public protocol ClassifiedAdRepository: Repository<ClassifiedAd> {}
