//
//  DancerModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/16/23.
//

import Foundation

class DancerModel: Identifiable, Codable {
    let id: UUID
    var number: Int
    var name: String
    var position: [Double]
    var path: [[CGFloat]]
    
    init(id: UUID = UUID(), number: Int, name: String = "", position: [Double], path: [[CGFloat]] = []) {
        self.id = id
        self.number = number
        self.name = name
        self.position = position
        self.path = path
    }
    
    
    func updatePosition(x: Double, y: Double) {
        self.position = [x, y]
    }
    
    
    func updatePath(newPath: [[CGFloat]]) {
        self.path = newPath
    }
}
