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
