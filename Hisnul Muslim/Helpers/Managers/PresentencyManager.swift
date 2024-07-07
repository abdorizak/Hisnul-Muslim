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

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Content, actionType: PersistenceActionType) async throws {
        do {
            var favorites = try await retrieveFavorites()
            
            switch actionType {
            case .add:
                guard !favorites.contains(favorite) else {
                    throw HSErrors.alreadyInFavorite
                }
                favorites.append(favorite)
            case .remove:
                favorites.removeAll { $0.id == favorite.id }
            }
            
            try await save(favorite: favorites)
        } catch {
            throw error
        }
    }
    
        
    static func retrieveFavorites() async throws -> [Content] {
        guard let favoritesData = defaults.object(forKey: keys.favorites) as? Data else {
            return []
        }
        
        do {
            let favorites = try JSONDecoder().decode([Content].self, from: favoritesData)
            return favorites
        } catch {
            throw HSErrors.unableToFavorite
        }
    }
    
    static func save(favorite: [Content]) async throws {
        do {
            let encoder = JSONEncoder()
            let encodeFovarite = try encoder.encode(favorite)
            defaults.set(encodeFovarite, forKey: keys.favorites)
        } catch {
            throw HSErrors.unableToFavorite
        }
    }

}
