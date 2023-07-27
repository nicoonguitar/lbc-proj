import Combine
import Design
import Foundation
import UIKit

final class ClassifiedAdDetailViewController: UIViewController {
    
    private let itemId: Int64
    
    private let viewModel: ClassifiedAdDetailViewModel
    
    /*
     Fetch data task lifecycle is managed by the view.
     We set a task as a ViewController property similar to how SwiftUI views provide
     and manage the task() modifier.
     */
    private var task: Task<Void, Never>?
    
    private var imageLoadingTask: Task<Void, Never>?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let wrappedView: ClassifiedAdView = .init(style: .fullScreen)
    
    init(
        itemId: Int64,
        viewModel: ClassifiedAdDetailViewModel
    ) {
        self.itemId = itemId
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindings() {
        viewModel.$detail
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detail in
                guard let detail else { return }
                self?.wrappedView.infoView.titleLabel.text = detail.title
                self?.wrappedView.infoView.categoryLabel.text = detail.category
                self?.wrappedView.infoView.priceLabel.text = detail.price
                self?.wrappedView.infoView.dateLabel.text = detail.creationDate
                self?.wrappedView.infoView.descriptionLabel.text = detail.description
                self?.wrappedView.badgeView.isHidden = !detail.isUrgent
                
                guard let imageURL = detail.image else { return }
                self?.imageLoadingTask?.cancel()
                self?.imageLoadingTask = Task { @MainActor in
                    do {
                        let image = try await ImageLoader.shared.fetch(imageURL)
                        self?.wrappedView.imageView.image = image
                    } catch {
                        self?.wrappedView.imageView.image = Assets.placeholder
                    }
                }
            }.store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout
        var constraints: [NSLayoutConstraint] = []
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        constraints.append(contentsOf: [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        wrappedView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(wrappedView)
        constraints.append(contentsOf: [
            // Pin the edges of the stack view to the edges of the scroll view that contains it
            wrappedView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            wrappedView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            wrappedView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            wrappedView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            // Set the width of the stack view to the width of the scroll view for vertical scrolling
            wrappedView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        NSLayoutConstraint.activate(constraints)

        // View customization
        view.backgroundColor = .white
        wrappedView.badgeView.set(text: "Urgent")
        
        bindings()
        
        task?.cancel()
        task = Task {
            await viewModel.fetchItem(id: itemId)
        }
    }
}
