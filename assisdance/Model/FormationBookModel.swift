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
}
