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
    weak var delegate: SchedulerDelegate!
    init() { }
    
    func index(_ index: Int) -> HSMSchedulers {
        self.schedulers[index]
    }
    
    func fetchSchedulersData() {
        let schedulers_result = schedulerdata.fetchData()
        guard let result = schedulers_result else { fatalError("N/A") }
        self.schedulers = result
        self.delegate.didFinishLoadingSchedulers()
    }
}
