//
//  Page.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/3/23.
//

import Foundation

// MARK: - Page
struct Page: Codable, Hashable {
    let page: Int
    let content, reference: String
}
