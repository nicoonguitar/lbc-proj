import Foundation
import UIKit

public final class ClassifiedAdView: UIStackView {

    public let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        return view
    }()
    
    public let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.lineBreakMode = .byTruncatingTail
        view.textColor = .black
        view.font = .systemFont(ofSize: 16, weight: .bold)
        return view
    }()
        
    public let priceLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.textColor = .black
        view.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()
    
    public let categoryLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.textColor = .gray
        view.font = .systemFont(ofSize: 14, weight: .regular)
        return view
    }()
    
    public let badgeView = BadgeView()
    
    public init() {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .fill
        alignment = .leading
        spacing = 4
        
        var constraints: [NSLayoutConstraint] = []
        
        // Image layout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(imageView)
        constraints.append(
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: 1.25
            )
        )

        // Badge layout
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(badgeView)
        constraints.append(contentsOf: [
            badgeView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            badgeView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8)
        ])
        
        // Title layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleContainerView = UIView()
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleContainerView.addSubview(titleLabel)
        addArrangedSubview(titleContainerView)
        constraints.append(contentsOf: [
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor)
        ])
        
        // Price layout
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(priceLabel)
        
        // Category layout
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(categoryLabel)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// For preview purposes
private extension ClassifiedAdView {
    func set(
        title: String,
        category: String,
        isUrgent: Bool,
        price: Float
    ) {
        titleLabel.text = title
        categoryLabel.text = category
        priceLabel.text = "Price: \(price) €"
        imageView.image = UIImage(named: "placeholder", in: .module, with: nil)
        
        badgeView.isHidden = !isUrgent
        badgeView.set(text: "Urgent")
    }
}

import SwiftUI

#if DEBUG
struct ClassifiedAdView_Previews: PreviewProvider {
        
    static var view: some View {
        VStack {
            Spacer()
            UIViewPreview {
                let view = ClassifiedAdView()
                view.set(
                    title: "Hello",
                    category: "Category",
                    isUrgent: true,
                    price: 100.00
                )
                return view
            }
            .frame(width: 150, height: 300)
            Spacer()
        }
    }
    
    static var previews: some View {
        view
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .previewDisplayName("iPhone 14")
    }
}
#endif
