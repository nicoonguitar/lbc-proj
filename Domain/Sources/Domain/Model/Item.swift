import Foundation

public struct Item: Equatable {
    public struct Images: Equatable {
        public let small: String?
        public let thumb: String?
    }
    
    public let id: Int64
    public let title: String
    public let categoryId: Int64
    public let creationDate: Date
    public let description: String
    public let imagesURL: Images
    public let isUrgent: Bool
    public let price: Float
    public let siret: String?
}

extension Item: Comparable {
    public static func < (lhs: Item, rhs: Item) -> Bool {
        if lhs.isUrgent == rhs.isUrgent {
            return lhs.creationDate > rhs.creationDate
        }
        return lhs.isUrgent && !rhs.isUrgent
    }
}
