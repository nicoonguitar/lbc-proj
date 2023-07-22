import Foundation

protocol InMemoryCache<T>: AnyActor where T: Hashable {
    associatedtype T
    
    static var shared: Self { get }

    var cache: Set<T> { get async }
    
    func save(_ items: [T]) async
        
    func clean() async
}
