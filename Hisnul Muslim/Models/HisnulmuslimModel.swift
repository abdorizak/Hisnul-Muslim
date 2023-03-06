//
//  HisnulmuslimModel.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/3/23.
//

import Foundation

// MARK: - HisnulmuslimModel
struct HisnulmuslimModel: Decodable {
    let kutubName, kutubAuthor, publisher, distributor: String
    let date: String
    let content: [Content]
    
    enum CodingKeys: String, CodingKey {
        case kutubName = "Kutub_name"
        case kutubAuthor = "Kutub_author"
        case publisher, distributor
        case date = "Date"
        case content
    }
}
