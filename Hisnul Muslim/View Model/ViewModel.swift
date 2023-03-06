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

class HisnulmuslimListViewModel {
    var hs_muslim: [HisnulmuslimViewModel]
    
    init() {
        self.hs_muslim = [HisnulmuslimViewModel]()
    }
    
    func hsVM(at index: Int) -> HisnulmuslimViewModel {
        self.hs_muslim[index]
    }
    
}

struct HisnulmuslimViewModel {
    let hs_muslim_dua: Content
    
    var dua_id: Int {
        self.hs_muslim_dua.id
    }
    
    var dua_title: String {
        self.hs_muslim_dua.title
    }
    
    var dua_pages: [Page] {
        self.hs_muslim_dua.pages
    }
}







