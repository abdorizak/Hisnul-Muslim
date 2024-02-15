//
//  HSErrors.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 4/1/23.
//

import Foundation

enum HSErrors: String, Error {
    case alreadyInFavorite = "موجود بالفعل في مفضلة الأدعية..."
    case unableToFavorite = "غير قادر على إضافة هذا إلى المفضلة، لأنه موجود بالفعل في المفضلة"
    case invalidContext = "invalid Context...."
}
