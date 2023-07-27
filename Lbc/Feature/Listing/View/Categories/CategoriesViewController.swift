import Combine
import Foundation
import UIKit

final class CategoriesViewController: UITableViewController {
    
    private let viewModel: ListingViewModel
    
    /*
     Fetch data task lifecycle is managed by the view.
     We set a task as a ViewController property similar to how SwiftUI views provide
     and manage the task() modifier.
     */
    private var task: Task<Void, Never>?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let closeBarItem: UIBarButtonItem = {
        let view = UIBarButtonItem(systemItem: .close)
        view.tintColor = .orange
        return view
    }()

    init(viewModel: ListingViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindings() {
        viewModel.$categories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
            }.store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Filter bar button item setup
        navigationItem.rightBarButtonItem = closeBarItem
        closeBarItem.primaryAction = .init() { [weak self] _ in
            // TODO: relocate to Coordinator
            self?.dismiss(animated: true)
        }
        
        // UITableView setup
        tableView.register(
            CategoryTableViewCell.self,
            forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier
        )
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .orange
        let action = UIAction { [weak self] _ in
            self?.task?.cancel()
            self?.task = Task {
                await self?.viewModel.onFetchCategories()
            }
        }
        refreshControl?.addAction(action, for: .valueChanged)
        
        bindings()
        
        if viewModel.selectedCategory != nil {
            tableView.selectRow(at: .init(row: 0, section: 0), animated: true, scrollPosition: .middle)
        }
        
        Task {
            await viewModel.onFetchCategories()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier)!
        let uiModel = viewModel.categories[indexPath.row]
        cell.textLabel?.text = uiModel.name
        cell.textLabel?.textColor = uiModel.id == viewModel.selectedCategory?.id ? .orange : .black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        task?.cancel()
        task = Task {
            await viewModel.onCategorySelection(at: indexPath)
            // TODO: relocate to Coordinator
            dismiss(animated: true)
        }
    }
}
