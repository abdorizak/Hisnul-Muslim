//
//  Bundle+Ext.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 2/17/23.
//

import UIKit
import Combine

extension Bundle {
    func readFile(_ file: String) -> AnyPublisher<Data, HSErrors> {
        guard let fileURL = self.url(forResource: file, withExtension: nil) else {
            return Fail(error: HSErrors.fileNotFound).eraseToAnyPublisher()
        }
        
        return Just(fileURL)
            .tryMap { try Data(contentsOf: $0) }
            .mapError { _ in HSErrors.unableToReadFile }
            .eraseToAnyPublisher()
    }
    
    func decodable<T: Decodable>(type Model: T.Type, _ fileName: String) -> AnyPublisher<T, HSErrors> {
        readFile(fileName)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { _ in HSErrors.unableToReadFile }
            .eraseToAnyPublisher()
    }
}
