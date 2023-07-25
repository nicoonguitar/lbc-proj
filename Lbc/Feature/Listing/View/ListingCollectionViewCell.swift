import Design
import Foundation
import UIKit

final class ListingCollectionViewCell: UICollectionViewCell, Reusable {
    
    private let wrappedView: ClassifiedAdView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        // Layout
        wrappedView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrappedView)
        NSLayoutConstraint.activate([
            wrappedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            wrappedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wrappedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wrappedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        wrappedView.badgeView.set(text: "Urgent")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wrappedView.imageView.image = nil
        wrappedView.titleLabel.text = ""
        wrappedView.categoryLabel.text = ""
        wrappedView.priceLabel.text = ""
        wrappedView.badgeView.isHidden = true
    }
    
    func set(model: ListingRowUIModel) {
        wrappedView.titleLabel.text = model.title
        wrappedView.categoryLabel.text = model.category
        // Assumption: the prices are provided in Euro as currency
        wrappedView.priceLabel.text = "\(model.price) €"
        wrappedView.badgeView.isHidden = !model.isUrgent
    }
}
