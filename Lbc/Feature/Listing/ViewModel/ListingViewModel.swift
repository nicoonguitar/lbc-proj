import Foundation
import Domain

/// The ListingViewModel class is responsible for wiring the UI event, the business logic and resulting UI state related to a classified ads listing view and its content filtering via a given Category selection.
/// It communicates with the various use cases (GetCategoriesUseCase, GetItemUseCase, and GetSortedItemsUseCase) to fetch data and update its internal UI state.
/// The ViewModel also provides various methods to interact with the view and trigger navigation actions through the MainCoordinator.
///
/// Note: The reason properties and functions of the ViewModel are annotated with @MainActor instead of the whole class is because doing so
/// would make the ViewModel initializer async, which the Service Locator cannot manage.
final class ListingViewModel {
    
    private let getItemUseCase: GetItemUseCase
    
    private let getSortedItemsUseCase: GetSortedItemsUseCase
    
    private let getCategoriesUseCase: GetCategoriesUseCase
    
    @Published @MainActor
    private(set) var items: [ListingRowUIModel] = []
    
    @Published @MainActor
    private(set) var categories: [CategoryUIModel] = []
    
    @Published @MainActor
    private(set) var selectedCategory: CategoryUIModel?
        
    enum ContentState: Equatable {
        case idle
        case fetching
        case noContent
        case error(String)
    }
    
    @Published @MainActor
    private(set) var content: ContentState = .idle
    
    @Published @MainActor
    private(set) var navigationAction: MainCoordinator.NavigationAction?
    
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
                .build(from: $0.item, category: $0.category)
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
                .map {
                    .init(id: $0.id, name: $0.name)
                }
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
            
            navigationAction = .dismissCategories
            navigationAction = nil
        }
    }
    
    @MainActor
    func onItemSelection(at indexPath: IndexPath) {
        guard indexPath.row < items.count else { return }
        let id = items[indexPath.row].id
        navigationAction = .showClassifiedAdDetail(id: id)
        navigationAction = nil
    }
    
    @MainActor
    func onFilter() {
        navigationAction = .showCategories
        navigationAction = nil
    }
    
    @MainActor
    func onDismissCategories() {
        navigationAction = .dismissCategories
        navigationAction = nil
    }
}
