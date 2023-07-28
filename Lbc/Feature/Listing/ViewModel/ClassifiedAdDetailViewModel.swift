import Foundation
import Domain

/// The ClassifiedAdDetailViewModel class is responsible for wiring the UI event, the business logic and resulting UI state related to displaying the details of a specific classified ad.
/// It communicates with the GetItemUseCase to fetch the classified ad's details and updates its internal state to provide data to the view.
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
            // As we fetch data from the same source (listings json) deterministically we'll find associated data
            // for the given ID in the cache. If instead we could call an server API, then we could manage and display errors.
        }
    }
}
