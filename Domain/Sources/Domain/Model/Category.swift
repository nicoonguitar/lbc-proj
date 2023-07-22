import Foundation

public struct Category: Equatable, Hashable, Identifiable {
    public let id: Int64
    public let name: String
    
    public init(
        id: Int64,
        name: String
    ) {
        self.id = id
        self.name = name
    }
}
