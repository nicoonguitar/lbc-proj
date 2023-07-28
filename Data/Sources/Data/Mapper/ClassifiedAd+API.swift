import Foundation
import Domain

extension ClassifiedAd {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    static func build(
        from apiModel: ApiClassifiedAd
    ) -> ClassifiedAd? {
        guard let creationDate = dateFormatter.date(from: apiModel.creationDate) else {
            return nil
        }
        return .init(
            id: apiModel.id,
            title: apiModel.title,
            categoryId: apiModel.categoryId,
            creationDate: creationDate,
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
