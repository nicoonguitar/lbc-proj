import Domain
import Foundation

struct ListingRowUIModel: Equatable, Identifiable {
    let id: Int64
    let category: String
    let creationDate: String
    let image: URL?
    let isUrgent: Bool
    let price: String
    let title: String
}

extension ListingRowUIModel {
    
    static private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // Assumption: the prices are provided in Euro as currency
        formatter.locale = .init(identifier: "fr_FR")
        return formatter
    }()
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func build(from model: ClassifiedAd, category: Domain.Category?) -> Self {
        .init(
            id: model.id,
            category: category?.name ?? "",
            creationDate: dateFormatter.string(from: model.creationDate),
            image: {
                if let urlString = model.imagesURL.small {
                    return URL(string: urlString)
                }
                return nil
            }(),
            isUrgent: model.isUrgent,
            price: currencyFormatter.string(from: model.price as NSNumber) ?? "",
            title: model.title
        )
    }
}
