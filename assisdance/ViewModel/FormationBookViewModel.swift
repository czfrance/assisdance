//
//  FormationBookViewModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation
import UIKit

class FormationBookViewModel: NSObject, ObservableObject {
    @Published private var formationBookModel =  FormationBookModel()
    
    var sets: [SetModel] {
        return formationBookModel.sets
    }
    
    func addSet(_ set: SetModel){
        formationBookModel.addSet(set)
    }
    
    func deletSet(_ set: SetModel) {
        _ = formationBookModel.deleteSet(id: set.id)
    }
    
    func loadSets() {
        _ = formationBookModel.loadSets()
    }
    
    func saveSets() {
        _ = formationBookModel.save()
    }
    
    func createNewSet(name: String, numDancers: Int) -> SetModel {
        return formationBookModel.createNewSet(name: name, numDancers: numDancers)
    }
}
