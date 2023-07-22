import Foundation
import Domain

extension Item {
    
    static func build(
        from apiModel: ApiItem
    ) -> Self {
        return .init(
            id: apiModel.id,
            title: apiModel.title,
            categoryId: apiModel.categoryId,
            creationDate: {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                return formatter.date(from: apiModel.creationDate)!
            }(),
            description: apiModel.description,
            imagesURL: .init(
                small: apiModel.imagesURL.small,
                thumb: apiModel.imagesURL.thumb
            ),
            isUrgent: apiModel.isUrgent,
            price: apiModel.price,
            siret: apiModel.siret
        )
    }
}
