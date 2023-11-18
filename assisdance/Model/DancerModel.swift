//
//  DancerModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/16/23.
//

import Foundation

class DancerModel: Identifiable, Codable {
    let id: UUID
    var name: String = ""
    var position: [Double]
    var path: [Double]
    
    init(id: UUID = UUID(), position: [Double], path: [Double] = []) {
        self.id = id
        self.position = position
        self.path = path
    }
    
    func updatePosition(x: Double, y: Double) {
        self.position = [x, y]
    }
}
