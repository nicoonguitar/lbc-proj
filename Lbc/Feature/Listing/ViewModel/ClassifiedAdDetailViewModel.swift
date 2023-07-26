import Foundation
import Domain

final class ClassifiedAdDetailViewModel {
    
    private let getItemUseCase: GetItemUseCase
        
    @Published private(set) var detail: ClassifiedAdDetailUIModel?
    
    init(getItemUseCase: GetItemUseCase) {
        self.getItemUseCase = getItemUseCase
    }
    
    func fetchItem(id: Int64) async {
        if let result = await getItemUseCase(itemId: id) {
            detail = ClassifiedAdDetailUIModel.build(
                from: result.item,
                category: result.category
            )
        } else {
            // TODO: handle error
        }
    }
}
