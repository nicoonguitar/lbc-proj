import Foundation
import UIKit

public final class FillableBarButtonItem: UIBarButtonItem {
    
    public struct Model {
        public let filledImage: UIImage
        
        public let outlineImage: UIImage
        
        public init(
            filledImage: UIImage,
            outlineImage: UIImage
        ) {
            self.filledImage = filledImage
            self.outlineImage = outlineImage
        }
    }
    
    private let button: UIButton = .init(frame: .zero)
    
    private let model: Model
    
    public var isFilled: Bool = false {
        didSet {
            let image: UIImage = isFilled ? model.filledImage : model.outlineImage
            button.setImage(
                image.withTintColor(.orange, renderingMode: .alwaysOriginal),
                for: .normal
            )
        }
    }
    
    public init(model: Model) {
        self.model = model
        super.init()
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 32),
            button.widthAnchor.constraint(equalToConstant: 32)
        ])
        customView = button
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var primaryAction: UIAction? {
        didSet {
            guard let primaryAction else { return }
            button.addAction(primaryAction, for: .touchUpInside)
        }
    }
}

public extension FillableBarButtonItem.Model {
    static func buildFilter() -> Self {
        .init(
            filledImage: Assets.filterFill,
            outlineImage: Assets.filterOutline
        )
    }
}
