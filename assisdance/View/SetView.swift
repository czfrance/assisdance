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
                        Text("number of dancers: " + String(set.dancers))
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
                Button("Save") {
                    formationBook.addSet(set)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}


struct SetView_Previews_wrapper : View {
    func preview() -> SetModel {
        var curr_set = SetModel(name: "set", numDancers: 5)
        let formation1 = FormationModel(name: "formation 1")
        let formation2 = FormationModel(name: "formation 2")
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
