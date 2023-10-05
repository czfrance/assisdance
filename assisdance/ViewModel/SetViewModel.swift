//
//  SetViewModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation
import SwiftUI

class SetViewModel: NSObject, ObservableObject {

//    @Published private var setModel =  SetModel(id: UUID())
    var setModel: SetModel
    
    init(setModel: SetModel) {
        self.setModel = setModel
    }
    
    var name: String {
        return setModel.name
    }
    
    var image: Image {
        return Image(setModel.imageName)
    }

    var formations: [FormationModel] {
        return setModel.formations
    }
    
    func addSet(_ formation: FormationModel){
        setModel.addFormation(formation)
    }
}
