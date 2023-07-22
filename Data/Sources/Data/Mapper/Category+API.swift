import Foundation
import Domain

extension Domain.Category {
    
    static func build(
        from apiModel: ApiCategory
    ) -> Self {
        .init(
            id: apiModel.id,
            name: apiModel.name
        )
    }
}
