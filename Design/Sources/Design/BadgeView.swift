import Foundation
import UIKit

public final class BadgeView: UIView {
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.lineBreakMode = .byWordWrapping
        view.textColor = .orange
        view.textAlignment = .center
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.orange.cgColor
        
        // Title layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func set(text: String) {
        titleLabel.text = text
    }
}

import SwiftUI

#if DEBUG
struct BadgeLabel_Previews: PreviewProvider {
        
    static var view: some View {
        VStack {
            Spacer()
            UIViewPreview {
                let view = BadgeView()
                view.set(text: "Urgent")
                return view
            }
            .frame(height: 44)
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
