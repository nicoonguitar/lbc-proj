import Foundation
import Domain

/// The ListingViewModel class is responsible for wiring the UI event, the business logic and resulting UI state related to a classified ads listing view and its content filtering via a given Category selection.
/// It communicates with the various use cases (GetCategoriesUseCase, and GetSortedClassifiedAdsUseCase) to fetch data and update its internal UI state.
/// The ViewModel also provides various methods to interact with the view and trigger navigation actions through the MainCoordinator.
///
/// Note: The reason properties and functions of the ViewModel are annotated with @MainActor instead of the whole class is because doing so
/// would make the ViewModel initializer async, which the Service Locator cannot manage.
final class ListingViewModel {
        
    private let getSortedClassifiedAdsUseCase: GetSortedClassifiedAdsUseCase
    
    private let getCategoriesUseCase: GetCategoriesUseCase
    
    @Published @MainActor
    private(set) var classifiedAds: [ListingRowUIModel] = []
    
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
    private(set) var adsContent: ContentState = .idle
    
    @Published @MainActor
    private(set) var categoriesContent: ContentState = .idle
    
    @Published @MainActor
    private(set) var navigationAction: MainCoordinator.NavigationAction?
    
    init(
        getCategoriesUseCase: GetCategoriesUseCase,
        getSortedClassifiedAdsUseCase: GetSortedClassifiedAdsUseCase
    ) {
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getSortedClassifiedAdsUseCase = getSortedClassifiedAdsUseCase
    }
    
    @MainActor
    func fetchClassifiedAds(forceRefresh: Bool = true) async {
        do {
            self.adsContent = .fetching
            
            self.classifiedAds = try await getSortedClassifiedAdsUseCase(
                categoryId: selectedCategory?.id,
                forceRefresh: forceRefresh
            ).map {
                .build(from: $0.classifiedAd, category: $0.category)
            }
            
            self.adsContent = self.classifiedAds.isEmpty ? .noContent : .idle
            
        } catch {
            self.adsContent = .error(error.localizedDescription)
        }
    }

    @MainActor
    func onFetchCategories() async {
        do {
            self.categoriesContent = .fetching

            self.categories = try await getCategoriesUseCase(forceRefresh: true)
                .map {
                    .init(id: $0.id, name: $0.name)
                }
            
            self.categoriesContent = self.classifiedAds.isEmpty ? .noContent : .idle

        } catch {
            self.categoriesContent = .error(error.localizedDescription)
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
        guard indexPath.row < classifiedAds.count else { return }
        let id = classifiedAds[indexPath.row].id
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
