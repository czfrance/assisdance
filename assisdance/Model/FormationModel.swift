//
//  FormationModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

struct FormationModel: Identifiable, Codable, Equatable {
    static func == (lhs: FormationModel, rhs: FormationModel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    let name: String
//    var dancers: Dictionary<UUID, DancerModel>
    var dancers: [DancerModel]
    var tag: Int
    var transitionDuration: Double = 1.0
    
    init(name: String, dancers: [DancerModel], tag: Int) {
        self.id = UUID()
        self.name = name
        self.dancers = dancers
        self.tag = tag
    }
    
    
    func getDancer(dId: UUID) -> DancerModel? {
        for d in dancers {
            if d.id == dId {
               return d
            }
        }
        return nil
    }
    
    
    mutating func updateDancer(dId: UUID, x: Double, y: Double) {
        for d in dancers {
            if d.id == dId {
                d.updatePosition(x: x, y: y)
            }
        }
    }
    
    
    mutating func updateDancerPath(dId: UUID, path: [[CGFloat]]) {
        for d in dancers {
            if d.id == dId {
                d.updatePath(newPath: path)
            }
        }
    }
}
