//
//  Bundle+Ext.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 2/17/23.
//

import Foundation
import UIKit

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        do {
            let loaded = try decoder.decode(T.self, from: data)
            return loaded
        } catch {
            print(error)
            fatalError("Failed to decode \(error) from bundle.")
        }
    }
}
