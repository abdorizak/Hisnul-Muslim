//
//  Content.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/3/23.
//

import Foundation

// MARK: - Content
struct Content: Decodable {
    let id: Int
    let title: String
    let pages: [Page]
}
