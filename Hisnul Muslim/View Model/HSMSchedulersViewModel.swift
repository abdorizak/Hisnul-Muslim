//
//  HSMSchedulersViewModel.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/23/23.
//

import Foundation

protocol SchedulerDelegate: AnyObject {
    func didFinishLoadingSchedulers()
}

final class HSMSchedulerViewModel {
    let schedulerdata = HSMCoreDataHelper()
    private(set) var schedulers = [HSMSchedulers]()
    weak var delegate: SchedulerDelegate?
    init() { }
    
    func index(_ index: Int) -> HSMSchedulers {
        self.schedulers[index]
    }
    
    func fetchSchedulersData() {
        schedulerdata.fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let managedObjects):
                var schedulers = [HSMSchedulers]()
                for object in managedObjects {
                    if let id = object.value(forKey: "id") as? UUID,
                       let name = object.value(forKey: "adkarName") as? String,
                       let hour = object.value(forKey: "hour") as? String,
                       let minute = object.value(forKey: "minute") as? String {
                        let scheduler = HSMSchedulers(id: id, adkarName: name, hour: hour, minute: minute)
                        schedulers.append(scheduler)
                    }
                }
                self.schedulers = schedulers
                self.delegate?.didFinishLoadingSchedulers()
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }

    
    
    
    
}
