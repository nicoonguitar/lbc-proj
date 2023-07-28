import Foundation

struct ApiClassifiedAd: Decodable, Equatable {
    struct Images: Decodable, Equatable {
        let small: String?
        let thumb: String?
    }
    
    let id: Int64
    let title: String
    let categoryId: Int64
    let creationDate: String
    let description: String
    let imagesURL: Images
    let isUrgent: Bool
    let price: Float
    let siret: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case categoryId = "category_id"
        case creationDate = "creation_date"
        case description
        case imagesURL = "images_url"
        case isUrgent = "is_urgent"
        case price
        case siret
    }
}
