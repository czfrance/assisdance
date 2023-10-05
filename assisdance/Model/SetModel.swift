//
//  SetModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation
import SwiftUI

struct SetModel: Identifiable {
    
    var id: UUID
    var name: String
    var imageName: String
    var image: Image
    var dancers: Int
    
    init(name: String, numDancers: Int, imageName: String? = nil) {
        self.id = UUID()
        self.name = name
        self.dancers = numDancers
        if let imageName = imageName {
            self.imageName = imageName
        }
        else {
            self.imageName = "defaultSetImage"
        }
        self.image = Image(self.imageName)
    }
    
    private(set) var formations :[FormationModel] = []
    
    mutating func addFormation(_ formation: FormationModel) {
        formations.append(formation)
    }
    
    func numDancers() -> Int {
        return dancers
    }
}
