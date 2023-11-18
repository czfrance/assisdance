//
//  SetView.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/5/23.
//

import SwiftUI

struct SetView: View {
    
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State var set: SetModel
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text(set.name).font(.system(size: 24, weight: .bold, design: .default))
                        Text("number of dancers: " + String(set.numDancers))
                    }
                    Spacer()
                }
                .padding(.top, 50)
                Spacer()
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(set.formations) { formation in
                            FormationView(formation: formation)
                                .frame(height: geometry.size.height*0.5)
                        }
                    }
                }
                Spacer()
                Button("Add Formation") {
                    let lastFormation = set.formations.last!
                    var newDancers: [DancerModel] = []
                    for d in lastFormation.dancers {
                        newDancers.append(DancerModel(id: d.id, position: [d.position[0], d.position[1]]))
                    }
                    let newFormation = FormationModel(name: "formation \(set.formations.count + 1)", dancers: newDancers)
                    set.addFormation(newFormation)
                    formationBook.saveSets()
                    print(set)
                    for s in formationBook.sets {
                        print(s)
                    }
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                Button("Save") {
                    formationBook.addSet(set)
                    formationBook.saveSets()
                    print(set)
                    for s in formationBook.sets {
                        print(s)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}


struct SetView_Previews_wrapper : View {
    func preview() -> SetModel {
        var curr_set = SetModel(name: "set", numDancers: 5)
        let dancer1 = DancerModel(position: [25.0, 25.0])
        let dancer2 = DancerModel(position: [50.0, 50.0])
        let formation1 = FormationModel(name: "formation 1", dancers: [dancer1, dancer2])
        let formation2 = FormationModel(name: "formation 2", dancers: [dancer1, dancer2])
        curr_set.addFormation(formation1)
        curr_set.addFormation(formation2)
        return curr_set
    }
    
    var body: some View {
        SetView(set: preview())
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        SetView_Previews_wrapper()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
