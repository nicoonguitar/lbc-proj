import Combine
import Data
import Design
import Domain
import Foundation
import UIKit

final class ListingViewController: UIViewController {
    
    private let viewModel: ListingViewModel
    
    private weak var coordinator: MainCoordinator?
    
    private let fillableBarButtonItem = FillableBarButtonItem(
        model: .buildFilter()
    )
    
    /*
     Fetch data task lifecycle is managed by the view.
     We set a task as a ViewController property similar to how SwiftUI views provide
     and manage the task() modifier.
     */
    private var task: Task<Void, Never>?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = .orange
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.buildListingLayout()
        )
        return view
    }()
    
    private var errorLabel: UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    init(
        viewModel: ListingViewModel,
        coordinator: MainCoordinator?
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        var constraints: [NSLayoutConstraint] = []
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        constraints.append(contentsOf: [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupNavigationBar() {
        title = "Listing"

        // Filter bar button item setup
        navigationItem.rightBarButtonItem = fillableBarButtonItem
        
        fillableBarButtonItem.primaryAction = .init() { [weak self] _ in
            self?.viewModel.onFilter()
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(
            ListingCollectionViewCell.self,
            forCellWithReuseIdentifier: ListingCollectionViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    private func setupPullToRefresh() {
        let action = UIAction { [weak self] _ in
            self?.task?.cancel()
            self?.task = Task {
                await self?.viewModel.fetchClassifiedAds()
            }
        }
        refreshControl.addAction(action, for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // View customization
        view.backgroundColor = .white
        
        setupLayout()
        setupNavigationBar()
        setupCollectionView()
        setupPullToRefresh()
        setupBindings()
        
        // We fetch data when the view appears UI event
        task?.cancel()
        task = Task {
            await viewModel.fetchClassifiedAds()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.buildListingLayout(),
            animated: true
        )
    }
    
    private func setupBindings() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
            }.store(in: &cancellables)
        
        viewModel.$content
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .idle:
                    self.collectionView.backgroundView = nil
                case .fetching:
                    self.refreshControl.beginRefreshing()
                case .noContent:
                    let label = self.errorLabel
                    label.text = "Empty results"
                    self.collectionView.backgroundView = label
                case let .error(error):
                    let label = self.errorLabel
                    label.text = error
                    self.collectionView.backgroundView = label
                }
            }.store(in: &cancellables)
        
        viewModel.$selectedCategory
            .map { $0 != nil }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.fillableBarButtonItem.isFilled = $0
            }.store(in: &cancellables)
        
        viewModel.$navigationAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                guard let self, let action else { return }
                self.coordinator?.onNavigationAction(action, origin: self)
            }.store(in: &cancellables)
    }
}

extension ListingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListingCollectionViewCell.reuseIdentifier, for: indexPath) as! ListingCollectionViewCell
        cell.set(model: viewModel.items[indexPath.row])
        return cell
    }
}

extension ListingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.onItemSelection(at: indexPath)
    }
}
