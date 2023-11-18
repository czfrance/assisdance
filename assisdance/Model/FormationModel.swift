//
//  FormationModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

struct FormationModel: Identifiable, Codable {
    let id: UUID
    let name: String
//    var dancers: Dictionary<UUID, DancerModel>
    var dancers: [DancerModel]
//    var tag: Int
    
    init(name: String, dancers: [DancerModel]) {
        self.id = UUID()
        self.name = name
        self.dancers = dancers
//        self.tag = tag
    }
    
//    mutating func updateDancer(dId: UUID, x: Double, y: Double) {
//        if dancers.keys.contains(dId) {
//            let dancer = dancers[dId]
//            let newDancer = DancerModel(id: dancer!.id, position: (x, y), path: dancer!.path)
//            dancers[dId] = newDancer
//        }
//        else {
//            print("dancer doesnt exist")
//            return
//        }
//    }
    
    mutating func updateDancer(dId: UUID, x: Double, y: Double) {
        for d in dancers {
            if d.id == dId {
                d.updatePosition(x: x, y: y)
//                let newDancer = DancerModel(id: d.id, position: [x, y], path: d.path)
//                dancers[i] = newDancer
            }
        }
    }
}
