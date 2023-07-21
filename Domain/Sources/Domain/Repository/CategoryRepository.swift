import Foundation

public protocol CategoryRepository: AnyObject {
    func all(
        forceRefresh: Bool
    ) async throws -> [Category]
}
