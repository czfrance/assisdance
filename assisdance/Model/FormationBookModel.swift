//
//  FormationBookModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

struct FormationBookModel {
    private(set) var sets :[SetModel] = []
    
    mutating func addSet(_ set: SetModel){
        sets.append(set)
    }
    
    func loadSets() {
        return
    }
    
    mutating func createNewSet(name: String, numDancers: Int) -> SetModel {
        var newSet = SetModel(name: name, numDancers: numDancers)
        let firstFormation = FormationModel(name: "formation 1")
        newSet.addFormation(firstFormation)
        sets.append(newSet)
        
        return newSet
    }
}
