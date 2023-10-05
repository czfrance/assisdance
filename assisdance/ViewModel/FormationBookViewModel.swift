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
    
    func loadSets() {
        formationBookModel.loadSets()
    }
    
    func createNewSet(name: String, numDancers: Int) -> SetModel {
        return formationBookModel.createNewSet(name: name, numDancers: numDancers)
    }
}
