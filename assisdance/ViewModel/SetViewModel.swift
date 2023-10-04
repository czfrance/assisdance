//
//  SetViewModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

class SetViewModel: NSObject, ObservableObject {

    @Published private var setModel =  SetModel(id: UUID())

    var formations: [FormationModel] {
        return setModel.formations
    }
    
    func addSet(_ formation: FormationModel){
        setModel.addFormation(formation)
    }
}
