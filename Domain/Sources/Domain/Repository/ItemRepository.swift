import Foundation

public protocol ItemRepository: AnyObject {
    func all(
        forceRefresh: Bool
    ) async throws -> [Item]
    
    func item(for id: Int64) -> Item?
}
