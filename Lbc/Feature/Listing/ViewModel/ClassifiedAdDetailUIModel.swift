import Foundation
import Domain

struct ClassifiedAdDetailUIModel: Equatable {
    let category: String
    let creationDate: String
    let description: String
    let image: URL?
    let isUrgent: Bool
    let price: String
    let title: String
}

extension ClassifiedAdDetailUIModel {
        
    static private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // Assumption: the prices are provided in Euro as currency
        formatter.locale = .init(identifier: "fr_FR")
        return formatter
    }()
    
    static private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func build(from model: Item, category: Domain.Category?) -> Self {
        .init(
            category: category?.name ?? "",
            creationDate: dateFormatter.string(from: model.creationDate),
            description: model.description,
            image: {
                if let urlString = model.imagesURL.thumb {
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
