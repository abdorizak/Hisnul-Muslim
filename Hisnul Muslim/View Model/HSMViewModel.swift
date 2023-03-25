//
//  ViewModel.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/3/23.
//

import Foundation
import UIKit

// MARK: - HSM Protocol
protocol HSMDelegate: AnyObject {
    func didFinish()
}

class HSMViewModel {
    private(set) var hs_mslm = [Content]()
    
    weak var delegate: HSMDelegate?
    
    init() { }
    
    func index(_ index: Int) -> Content {
        self.hs_mslm[index]
    }
    
    func getHSMData() {
        let data = self.getHisnulmuslimData()
        self.hs_mslm = data.content
        self.delegate?.didFinish()
    }
    
    func getHisnulmuslimData() -> HisnulmuslimModel {
        let hisnulmuslim: HisnulmuslimModel = Bundle.main.decode(HisnulmuslimModel.self, from: "hisnul_muslim.json")
        return hisnulmuslim
    }
}
