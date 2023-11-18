//
//  FormationBookModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

struct FormationBookModel {
    var sets: [SetModel] = []
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    let databaseURL = DocumentsDirectory.appendingPathComponent("FormationBook.json")
    
    mutating func addSet(_ set: SetModel){
        for (i, currSet) in sets.enumerated(){
            if currSet.id == set.id{
                sets.remove(at: i)
                break
            }
        }
        sets.append(set)
        _ = save()
    }
    
    mutating func deleteSet(id: UUID) -> Bool {
        for i in 0..<sets.count {
            if (sets[i].id == id) {
                sets.remove(at: i)
                _ = save()
                return true
            }
        }
        return false
    }
    
    mutating func loadSets() -> Bool {
        let tempData: Data
        do {
           tempData = try Data(contentsOf: databaseURL)
        } catch _ as NSError {
            do {
                let bundle: Bundle = .main
                if let defaultData = bundle.url(forResource: "FormationBook", withExtension: "json") {
                    tempData = try Data(contentsOf: defaultData)
                }
                else {
                    return false
                }
            } catch let error as NSError {
                print("error finding formation book file \(error)")
                return false
            }
        }
        
        return decode(data: tempData)
    }
    
    mutating func decode(data: Data) -> Bool {
        self.sets = [SetModel]()
        if let decoded = try? JSONDecoder().decode([SetModel].self, from: data) {
            for set in decoded {
                self.sets.append(set)
            }
            return true
        } else {
            return false
        }
    }
    
    func save() -> Bool {
        print("saving!")
        var outputData = Data()
        let encoder = JSONEncoder()
    
        if let encoded = try? encoder.encode(sets) {
            if let _ = String(data: encoded, encoding: .utf8) {
                outputData = encoded
            }
            else { return false }
            
            do {
                try outputData.write(to: databaseURL)
            } catch let error as NSError {
                print ("error writing to formation book file \(error)")
                return false
            }
            return true
        }
        else { return false }
    }
    
    mutating func createNewSet(name: String, numDancers: Int) -> SetModel {
        var newSet = SetModel(name: name, numDancers: numDancers)
        let dancer1 = DancerModel(position: [25.0, 25.0])
        let dancer2 = DancerModel(position: [50.0, 50.0])
        let firstFormation = FormationModel(name: "formation 1", dancers: [dancer1, dancer2])
        newSet.addFormation(firstFormation)
        self.addSet(newSet)
        
        print("added new set")
        print(sets)
        
        return newSet
    }
}
