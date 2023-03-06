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
    
}
