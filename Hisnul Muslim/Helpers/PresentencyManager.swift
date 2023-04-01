//
//  PresentencyManager.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/12/23.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum HSErrors: String, Error {
    case alreadyInFavorite = "Already In Favorite.."
    case unableToFavorite = "Unable To Favorate"
    case invalidContext = "invalidContext...."
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Content, actionType: PersistenceActionType, completion: @escaping(HSErrors?) -> Void) {
        retrieveFavorites { result  in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(favorite) else {
                        completion(.alreadyInFavorite)
                        return
                    }
                    favorites.append(favorite )
                case .remove:
                    favorites.removeAll { $0.id == favorite.id  }
                }
                
                completion(save(favorite: favorites))
                
            case .failure(let err):
                completion(err)
            }
        }
        
    }
    
    static func retrieveFavorites(completion: @escaping (Result<[Content], HSErrors>) -> Void) {
        guard let favoritesData = defaults.object(forKey: keys.favorites) as? Data else {
            completion(.success([]))
            return
        }
        
        do {
            let favorites = try JSONDecoder().decode([Content].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorite: [Content]) -> HSErrors? {
        do {
            let encoder = JSONEncoder()
            let encodeFovarite = try encoder.encode(favorite)
            defaults.set(encodeFovarite, forKey: keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}
