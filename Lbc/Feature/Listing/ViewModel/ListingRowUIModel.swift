import Domain
import Foundation

struct ListingRowUIModel: Equatable, Identifiable {
    let id: Int64
    let category: String
    let image: URL?
    let isUrgent: Bool
    let price: Float
    let title: String
}

extension ListingRowUIModel {
    static func build(from model: Item, category: Domain.Category?) -> Self {
        .init(
            id: model.id,
            category: category?.name ?? "",
            image: {
                if let urlString = model.imagesURL.small {
                    return URL(string: urlString)
                }
                return nil
            }(),
            isUrgent: model.isUrgent,
            price: model.price,
            title: model.title
        )
    }
}
