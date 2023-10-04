//
//  helpers.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
