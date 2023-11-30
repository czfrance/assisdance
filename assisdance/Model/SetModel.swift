//
//  SetModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation
import SwiftUI

struct SetModel: Identifiable, Codable {
    
    var id: UUID
    var name: String
//    var imageName: String
//    var image: Image
    var numDancers: Int
    private(set) var formations: [FormationModel] = []
    
    init(name: String, numDancers: Int, imageName: String? = nil) {
        self.id = UUID()
        self.name = name
        self.numDancers = numDancers
//        if let imageName = imageName {
//            self.imageName = imageName
//        }
//        else {
//            self.imageName = "defaultSetImage"
//        }
//        self.image = Image(self.imageName)
    }
    
    mutating func addFormation(_ formation: FormationModel) {
        formations.append(formation)
    }
    
    func getNumDancers() -> Int {
        return numDancers
    }
    
    mutating func updateFormation(fId: UUID, fDuration: Double, tDuration: Double) {
        for f in formations {
            if f.id == fId {
                f.updateFormationDuration(newDuration: fDuration)
                f.updateTransitionDuration(newDuration: tDuration)
            }
        }
    }
}
