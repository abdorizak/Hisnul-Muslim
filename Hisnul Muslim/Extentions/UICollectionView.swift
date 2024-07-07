//
//  UICollectionView+Ext.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/10/23.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
}

extension UICollectionViewDiffableDataSource where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    func applyOnMainThread(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }
}
