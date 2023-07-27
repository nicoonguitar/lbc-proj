import Foundation
import Domain

struct ClassifiedAdDetailUIModel: Equatable {
    let category: String
    let creationDate: String
    let description: String
    let image: URL?
    let isUrgent: Bool
    let price: Float
    let title: String
}

extension ClassifiedAdDetailUIModel {
    static func build(from model: Item, category: Domain.Category?) -> Self {
        .init(
            category: category?.name ?? "",
            // TODO: map date
            creationDate: "model.creationDate",
            description: model.description,
            image: {
                if let urlString = model.imagesURL.thumb {
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
