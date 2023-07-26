//
//  Listing+CompositionalLayout.swift
//  Lbc
//
//  Created by Nicolás García on 24/07/2023.
//

import Foundation
import UIKit

extension UICollectionViewCompositionalLayout {
    static func buildListingLayout() -> UICollectionViewCompositionalLayout {
        .init() { _, environment in
            let interItemSpacing: CGFloat = 16
            let sectionLateralInset: CGFloat = 16
            let minItemWidth: CGFloat = (320 / 2) - (sectionLateralInset * 2) //320 smallest iPhone screen w

            // Substracts section padding to available width
            var availableWidth: CGFloat = environment.container.contentSize.width - (sectionLateralInset * 2)
            // Computes number of columns
            let columns = Int(availableWidth / minItemWidth)
            // Substracts item interspacing width to available width
            availableWidth -= (interItemSpacing * CGFloat(columns - 1))
            // Computes item width based on container width - section padding - inter item spacing
            let itemWidth: CGFloat = availableWidth / CGFloat(columns)
            let imageHeight = itemWidth * 1.25
            let heightDimension: NSCollectionLayoutDimension = .estimated(imageHeight + 100)

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: heightDimension
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .zero
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: heightDimension
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.interItemSpacing = .fixed(interItemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(
                top: 0,
                leading: sectionLateralInset,
                bottom: 0,
                trailing: sectionLateralInset
            )
            section.interGroupSpacing = interItemSpacing
            return section
        }
    }
}
