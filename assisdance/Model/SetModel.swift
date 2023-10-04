//
//  SetModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

struct SetModel: Identifiable {
    
    let id: UUID
    private(set) var formations :[FormationModel] = []
    
    mutating func addFormation(_ formation: FormationModel) {
        formations.append(formation)
    }
}
