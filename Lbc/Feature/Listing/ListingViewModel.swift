import Foundation
import Domain

final class ListingViewModel {
    
    private let getItemUseCase: GetItemUseCase
    
    private let getSortedItemsUseCase: GetSortedItemsUseCase
    
    private let getCategoriesUseCase: GetCategoriesUseCase
    
    @Published private(set) var items: [ListingRowUIModel] = []
    
    @Published private(set) var categories: [Domain.Category] = []
    
    @Published private(set) var selectedCategory: Domain.Category?
    
    enum ContentState: Equatable {
        case idle
        case fetching
        case noContent
        case error(String)
    }
    
    @Published private(set) var content: ContentState = .idle
    
    init(
        getCategoriesUseCase: GetCategoriesUseCase,
        getItemUseCase: GetItemUseCase,
        getSortedItemsUseCase: GetSortedItemsUseCase
    ) {
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getItemUseCase = getItemUseCase
        self.getSortedItemsUseCase = getSortedItemsUseCase
    }
    
    private func fetchAllData() async {
        do {
            self.content = .fetching
            
            self.items = try await getSortedItemsUseCase(
                categoryId: selectedCategory?.id,
                forceRefresh: true
            ).map {
                ListingRowUIModel.build(
                    from: $0.item,
                    category: $0.category
                )
            }
            
            self.content = self.items.isEmpty ? .noContent : .idle
            
        } catch {
            self.content = .error(error.localizedDescription)
        }
    }
    
    func viewDidLoad() async {
        await fetchAllData()
    }
    
    func onPullToRefresh() async {
        await fetchAllData()
    }
    
    func onItemSelection(at indexPath: IndexPath) async {
//        let id = items[indexPath.row].id
//        guard let result = await getItemUseCase(itemId: id) else {
//            return
//        }
        
        // TODO: trigger navigation to Detail page with provided Item id
    }
}
