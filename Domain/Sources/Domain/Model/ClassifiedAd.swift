import Foundation

public struct ClassifiedAd: Equatable, Hashable, Identifiable {
    public struct Images: Equatable, Hashable {
        public let small: String?
        public let thumb: String?
        
        public init(
            small: String?,
            thumb: String?
        ) {
            self.small = small
            self.thumb = thumb
        }
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
    
    public init(
        id: Int64,
        title: String,
        categoryId: Int64,
        creationDate: Date,
        description: String,
        imagesURL: Images,
        isUrgent: Bool,
        price: Float,
        siret: String?
    ) {
        self.id = id
        self.title = title
        self.categoryId = categoryId
        self.creationDate = creationDate
        self.description = description
        self.imagesURL = imagesURL
        self.isUrgent = isUrgent
        self.price = price
        self.siret = siret
    }
}

extension ClassifiedAd: Comparable {
    public static func < (lhs: ClassifiedAd, rhs: ClassifiedAd) -> Bool {
        if lhs.isUrgent == rhs.isUrgent {
            return lhs.creationDate > rhs.creationDate
        }
        return lhs.isUrgent && !rhs.isUrgent
    }
}
