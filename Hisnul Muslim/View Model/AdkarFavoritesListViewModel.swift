//
//  AdkarFavoritesListViewModel.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 6/30/24.
//

import Foundation
import Combine


class AdkarFavoritesListViewModel {
    let event = PassthroughSubject<Event, Never>()
    @Published var state: State
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.state = State()
        event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &cancellables)
        
        getFavorites()
    }
    
    private func handleEvent(_ event: Event) {
        switch event {
        default:
            break
        }
    }
    
    func getFavorites() {
        Task {
            state.isLoading = true
            do {
                let result = try await PersistenceManager.retrieveFavorites()
                debugPrint("Favorites: \(result)")
                state.favorites = result
            } catch {
                event.send(.error(error))
            }
            state.isLoading = false
        }
    }
    
    func removeFavorite(favorite: Content) {
        Task {
            state.isLoading = true
            do {
                try await PersistenceManager.updateWith(favorite: favorite, actionType: .remove)
                state.favorites.removeAll { $0.id == favorite.id }
                event.send(.didRemoveFavorite)
            } catch {
                event.send(.error(error))
            }
            state.isLoading = false
        }
    }
}

extension AdkarFavoritesListViewModel {
    
    enum Event {
        case error(Error)
        case didRemoveFavorite
    }
    
    struct State {
        var isLoading: Bool = false
        var favorites: [Content] = []
    }
    
}
