//
//  ListingViewController.swift
//  Lbc
//
//  Created by Nicolás García on 22/07/2023.
//

import Combine
import Data
import Design
import Domain
import Foundation
import ServiceLocator
import UIKit

final class ListingViewController: UIViewController {
    
    private let viewModel: ListingViewModel
    // diff data source + compositional layout (iPhone/iPad)
    
    // little header view -> selected category name (idea)
    
    // nav bar button -> filter
    
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
    
    init(viewModel: ListingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Listing"
        view.backgroundColor = .white
                
        // Layout
        var constraints: [NSLayoutConstraint] = []
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        constraints.append(contentsOf: [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Collection view setup
        collectionView.register(
            ListingCollectionViewCell.self,
            forCellWithReuseIdentifier: ListingCollectionViewCell.reuseIdentifier
        )
        collectionView.dataSource = self
        //        collectionView.delegate = self

        // Pull to refresh
        let action = UIAction { [weak self] _ in
            self?.task?.cancel()
            self?.task = Task {
                await self?.viewModel.onPullToRefresh()
            }
        }
        refreshControl.addAction(action, for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate(constraints)
        bindings()
        
        task?.cancel()
        task = Task {
            await viewModel.viewDidLoad()
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
    
    private func bindings() {
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

/*
 Service Locator + assemblies on each package ✅
 
 ImageLoader
 - downloader
 - cache
 
 Design package
 - listing item
 - category item
 
 FiltersVC
 - how to communicate new selection ?
 - idea on modal dismiss callback to trigger GetSortedItemsUseCase...
 - new selection IndexPath is optional ?
 
 DetailVC
 
 Coordinator ?
 + access to DI container
 
 Disable dark mode
 
 */

