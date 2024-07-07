//
//  ViewModel.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/3/23.
//

import UIKit
import Combine

class HSMViewModel {
    
    let event = PassthroughSubject<Event, Never>()
    
    @Published var state: State
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.state = State()
        event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &cancellables)
        
        getHisnulmuslimData()
    }
    
    private func handleEvent(_ event: Event) {
        switch event {
        case .search(let value):
            state.filteredHs_mslm = state.hs_mslm.filter { $0.title.localizedCaseInsensitiveContains(value) }
        case .searchCancel:
            state.filteredHs_mslm = state.hs_mslm
        default:
            break
        }
    }
    
    // Fetch data
    func getHisnulmuslimData() {
        Bundle.main.decodable(type: HisnulmuslimModel.self, "hisnul_muslim.json")
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self?.event.send(.error(.unableToReadFile))
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.state.hs_mslm = result.content
                self.state.filteredHs_mslm = self.state.hs_mslm
            }.store(in: &cancellables)
    }
}

extension HSMViewModel {
    
    enum Event {
        case error(HSErrors)
        case search(String)
        case searchCancel
        case dataFetched([Content])
    }
    
    struct State {
        var hs_mslm: [Content] = []
        var filteredHs_mslm: [Content] = []
    }
}
