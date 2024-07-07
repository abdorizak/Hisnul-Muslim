//
//  HSMSchedulersViewModel.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/23/23.
//

import Foundation
import Combine

class HSMSchedulerViewModel {
    let event = PassthroughSubject<Event, Never>()
    @Published var state: State
    private var cancellables = Set<AnyCancellable>()
    init() {
        self.state = State()
        
        event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.handleEvent($0) }
            .store(in: &cancellables)
        
        getSchedulersData()
    }
    
    
    private func handleEvent(_ event: Event) {
        switch event {
        default:
            break
        }
    }
    
    // fetch data
    func getSchedulersData() {
        Task {
            state.isLoading = true
            do {
                let schedulers = try await HSMCoreDataHelper.shared.fetchData()
                let convertedSchedulers = schedulers.map { object -> HSMSchedulers in
                    let id = object.value(forKey: "id") as! UUID
                    let name = object.value(forKey: "adkarName") as! String
                    let hour = object.value(forKey: "hour") as! String
                    let minute = object.value(forKey: "minute") as! String
                    return HSMSchedulers(id: id, adkarName: name, hour: hour, minute: minute)
                }
                state.schedulers = convertedSchedulers
            } catch {
                event.send(.error(error))
            }
            state.isLoading = false
        }
    }
    
    // delete notification
    func deleteNotification(withID id: UUID) {
        Task {
            state.isLoading = true
            do {
                try await HSMCoreDataHelper.shared.deleteRecord(withID: id)
                state.schedulers.removeAll { $0.id == id }
                event.send(.didRemoveScheduler)
            } catch {
                event.send(.error(error))
            }
            state.isLoading = false
        }
    }
    
}

extension HSMSchedulerViewModel {
    enum Event {
        case error(Error), didRemoveScheduler
    }
    
    struct State {
        var isLoading: Bool = false
        var schedulers = [HSMSchedulers]()
    }
}

//final class HSMSchedulerViewModel {
//    let schedulerdata = HSMCoreDataHelper()
//    var schedulers = [HSMSchedulers]()
//    weak var delegate: SchedulerDelegate?
//    
//    init() { }
//    
//    func index(_ index: Int) -> HSMSchedulers {
//        self.schedulers[index]
//    }
//    
//    func fetchSchedulersData(completion: @escaping (Result<[HSMSchedulers], Error>) -> Void) {
//        schedulerdata.fetchData { result in
//            switch result {
//            case .success(let managedObjects):
//                var schedulers = [HSMSchedulers]()
//                for object in managedObjects {
//                    if let id = object.value(forKey: "id") as? UUID,
//                       let name = object.value(forKey: "adkarName") as? String,
//                       let hour = object.value(forKey: "hour") as? String,
//                       let minute = object.value(forKey: "minute") as? String {
//                        let scheduler = HSMSchedulers(id: id, adkarName: name, hour: hour, minute: minute)
//                        schedulers.append(scheduler)
//                    }
//                }
//                self.schedulers = schedulers
//                self.delegate?.didFinishLoadingSchedulers()
//                completion(.success(schedulers))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    
//    // implement delete function and update the UI
////    func deleteNotification(withID id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
////        HSMCoreDataHelper.shared.deleteRecord(withID: id, completion: completion)
////    }
//    
//}
