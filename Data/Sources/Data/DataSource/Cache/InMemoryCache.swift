import Foundation

/// The InMemoryCache protocol is designed to define the common interface for an in-memory cache that stores and manages data of a generic type T.
/// The protocol provides methods for saving, retrieving, and cleaning the cached data.
protocol InMemoryCache<T>: AnyActor where T: Hashable {
    associatedtype T
    
    static var shared: Self { get }

    /// Represents the set of cached items of type T. The property is asynchronously accessed, as it may involve asynchronous operations to retrieve the cached data.
    var cache: Set<T> { get async }
    
    /// Saves the provided array of items to the cache.
    /// - Parameter items: An array of items of type T to be saved to the cache.
    func save(_ items: [T]) async
    
    /// Cleans the cache by removing all stored items, resetting it to an empty state.
    func clean() async
}
