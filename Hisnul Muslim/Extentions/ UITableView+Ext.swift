//
//  UITableView+Ext.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/5/23.
//

import Foundation
import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
    
    func register<T: UITableViewCell>(_ cell: T.Type) {
        register(cell, forCellReuseIdentifier: cell.identifier)
    }
    
}

extension UITableViewDiffableDataSource where SectionIdentifierType: Hashable, ItemIdentifierType: Hashable {
    func applyOnMainThread(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.apply(snapshot, animatingDifferences: animatingDifferences, completion: completion)
        }
    }
}


extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
