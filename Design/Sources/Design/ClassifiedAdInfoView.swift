import Foundation
import UIKit

public enum ClassifiedAdViewStyle: Equatable {
    // Does not display description
    case cell
    // Displays description
    case fullScreen
}

public final class ClassifiedAdView: UIStackView {
        
    public let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .lightGray
        return view
    }()
    
    public let badgeView = BadgeView()
    
    public let infoView: ClassifiedAdInfoView
    
    public init(style: ClassifiedAdViewStyle) {
        infoView = .init(style: style)
        super.init(frame: .zero)
        axis = .vertical
        distribution = .fill
        alignment = .fill
        spacing = 4
                
        var constraints: [NSLayoutConstraint] = []
        
        // Image layout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(imageView)
        constraints.append(
            imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: style == .cell ? 1.25 : 1
            )
        )
        
        // Badge layout
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(badgeView)
        constraints.append(contentsOf: [
            badgeView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            badgeView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8)
        ])
        
        // Nested Info stackview layout
        infoView.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(infoView)

        NSLayoutConstraint.activate(constraints)
        
        // Style customization
        switch style {
        case .cell:
            imageView.layer.cornerRadius = 8
            infoView.layoutMargins = .zero
            
        case .fullScreen:
            imageView.layer.cornerRadius = 0
            infoView.layoutMargins = UIEdgeInsets(
                top: 0,
                left: 16,
                bottom: 0,
                right: 16
            )
            infoView.isLayoutMarginsRelativeArrangement = true
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public final class ClassifiedAdInfoView: UIStackView {
    
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
    
    public let dateLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.textColor = .gray
        view.font = .systemFont(ofSize: 14, weight: .regular)
        return view
    }()
    
    public lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textColor = .gray
        view.font = .systemFont(ofSize: 14, weight: .regular)
        return view
    }()
    
    public init(style: ClassifiedAdViewStyle) {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .fill
        alignment = .leading
        spacing = 4
        
        var constraints: [NSLayoutConstraint] = []
        
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
        
        // Category layout
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(dateLabel)
        
        if style == .fullScreen {
            // Description layout
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(descriptionLabel)
            addArrangedSubview(containerView)
            constraints.append(contentsOf: [
                descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
        
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
        infoView.titleLabel.text = title
        infoView.categoryLabel.text = category
        infoView.priceLabel.text = "\(price) €"
        infoView.dateLabel.text = "26 Jul 2023"
        imageView.image = UIImage(named: "placeholder", in: .module, with: nil)
        infoView.descriptionLabel.text = "= = = = = = = = = PC PORTABLE HP ELITEBOOK 820 G1 = = = = = = = = = # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # HP ELITEBOOK 820 G1 Processeur : Intel Core i5 4300M Fréquence : 2,60 GHz Mémoire : 4 GO DDR3 Disque Dur : 320 GO SATA Vidéo : Intel HD Graphics Lecteur Optique : Lecteur/Graveur CD/DVDRW Réseau : LAN 10/100 Système : Windows 7 Pro – 64bits Etat : Reconditionné  Garantie : 6 Mois Prix TTC : 199,00 € Boostez ce PC PORTABLE : Passez à la vitesse supérieure en augmentant la RAM : Passez de 4 à 6 GO de RAM pour 19€  Passez de 4 à 8 GO de RAM pour 29€  (ajout rapide, doublez la vitesse en 5 min sur place !!!) Stockez plus en augmentant la capacité de votre disque dur : Passez en 500 GO HDD pour 29€  Passez en 1000 GO HDD pour 49€  Passez en 2000 GO HDD pour 89€  Passez en SSD pour un PC 10 Fois plus rapide : Passez en 120 GO SSD pour 49€  Passez en 240 GO SSD pour 79€  Passez en 480 GO SSD pour 119€ # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # Nous avons plus de 300 Ordinateurs PC Portables. Visible en boutique avec une garantie de 6 mois vendu avec Facture TVA, pas de surprise !!!! Les prix varient en moyenne entre 150€ à 600€, PC Portables en stock dans notre boutique sur Paris. # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # KIATOO est une société qui regroupe à la fois: - PC Portable - PC de Bureau / Fixe - Chargeur PC Portable - Batterie PC Portable - Clavier PC Portable - Ventilateur PC Portable - Nappe LCD écran - Ecran LCD PC Portable - Mémoire PC Portable - Disque dur PC Portable - Inverter PC Portable - Connecteur Jack DC PC Portable ASUS, ACER, COMPAQ, DELL, EMACHINES, HP, IBM, LENOVO, MSI, PACKARD BELL, PANASONIC, SAMSUNG, SONY, TOSHIBA.."

        badgeView.isHidden = !isUrgent
        badgeView.set(text: "Urgent")
    }
}

import SwiftUI

#if DEBUG
struct ClassifiedAdDetailView_Previews: PreviewProvider {
        
    static var view: some View {
        VStack {
            Spacer()
            UIViewPreview {
                let view = ClassifiedAdView(style: .fullScreen)
                view.set(
                    title: "Hello",
                    category: "Category",
                    isUrgent: true,
                    price: 100.00
                )
                return view
            }
            .frame(width: 375)
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

