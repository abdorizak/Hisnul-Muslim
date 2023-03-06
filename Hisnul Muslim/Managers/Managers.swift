//
//  Managers.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 2/17/23.
//

import Foundation

class HisnulMuslimManager {
    static let shared = HisnulMuslimManager()
    
    private init() { }
    
    func getHisnulmuslimData() -> HisnulmuslimModel {
        let hisnulmuslim: HisnulmuslimModel = Bundle.main.decode(HisnulmuslimModel.self, from: "hisnul_muslim.json")
        return hisnulmuslim
    }
}
