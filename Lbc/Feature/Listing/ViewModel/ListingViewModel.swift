import Foundation
import Domain

final class ListingViewModel {
    
    private let getItemUseCase: GetItemUseCase
    
    private let getSortedItemsUseCase: GetSortedItemsUseCase
    
    private let getCategoriesUseCase: GetCategoriesUseCase
    
    @Published private(set) var items: [ListingRowUIModel] = []
    
    @Published private(set) var categories: [CategoryUIModel] = []
    
    @Published private(set) var selectedCategory: CategoryUIModel?
        
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
    
    @MainActor
    func fetchClassifiedAds(forceRefresh: Bool = true) async {
        do {
            self.content = .fetching
            
            self.items = try await getSortedItemsUseCase(
                categoryId: selectedCategory?.id,
                forceRefresh: forceRefresh
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

    @MainActor
    func onFetchCategories() async {
        do {
            self.categories = try await getCategoriesUseCase(forceRefresh: true)
                .map { .init(id: $0.id, name: $0.name) }
        } catch {
            // TODO: handle error
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    func onCategorySelection(at indexPath: IndexPath) async {
        if indexPath.row < categories.count {
            let newSelection = categories[indexPath.row]
            if selectedCategory?.id == newSelection.id {
                selectedCategory = nil
            } else {
                selectedCategory = newSelection
            }
            await fetchClassifiedAds(forceRefresh: false)
        }
    }
    
    func onItemSelection(at indexPath: IndexPath) async {
//        let id = items[indexPath.row].id
//        guard let result = await getItemUseCase(itemId: id) else {
//            return
//        }
        
        // TODO: trigger navigation to Detail page with provided Item id
    }
    
//    func onFilter() {
//        
//    }
    

}
