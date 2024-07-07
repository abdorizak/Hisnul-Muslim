//
//  UIVC+Ext.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/14/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlertOnMainThread(title: String, message: String, type: AlertVC.AlertAction = .ok) {
        DispatchQueue.main.async {
            let ac = AlertVC(title: title, message: message, actions: [type])
            ac.modalPresentationStyle = .overFullScreen
            ac.modalTransitionStyle = .crossDissolve
            self.present(ac, animated: true)
        }
    }
    
}

extension Hasher {
    @inlinable mutating func combine(values: any Hashable...) {
        values.forEach { self.combine($0) }
    }
}
