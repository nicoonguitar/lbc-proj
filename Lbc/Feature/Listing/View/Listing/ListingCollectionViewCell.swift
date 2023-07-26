import Design
import Foundation
import UIKit

final class ListingCollectionViewCell: UICollectionViewCell, Reusable {
    
    private let wrappedView: ClassifiedAdView
    
    override init(frame: CGRect) {
        wrappedView = .init(style: .cell)
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
        wrappedView.infoView.titleLabel.text = ""
        wrappedView.infoView.categoryLabel.text = ""
        wrappedView.infoView.priceLabel.text = ""
        wrappedView.badgeView.isHidden = true
    }
    
    func set(model: ListingRowUIModel) {
        wrappedView.infoView.titleLabel.text = model.title
        wrappedView.infoView.categoryLabel.text = model.category
        // Assumption: the prices are provided in Euro as currency
        wrappedView.infoView.priceLabel.text = "\(model.price) €"
        wrappedView.badgeView.isHidden = !model.isUrgent
    }
}
