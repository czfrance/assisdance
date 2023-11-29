//
//  FormationView.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/5/23.
//

import SwiftUI

struct FormationView: View {
    
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State var set: SetModel
    @State var formation: FormationModel
    @State private var dancerTransition: String = "AHH"
    @State private var drawPath = false
    @Binding var pageIndex: Int
    
    var body: some View {
        GeometryReader { geometry in
            Color(red: 242/255, green: 242/255, blue: 242/255)
            VStack {
                HStack {
                    Spacer()
                    Text(formation.name).font(.system(size: 24, weight: .bold, design: .default))
                    Spacer()
                }
                .padding(.top, 25)
                SingleFormationView(formation: formation, nextFormation: getNextFormation(), pageIndex: $pageIndex)
                    .frame(width: geometry.size.width > geometry.size.height ? geometry.size.height*(4/3) : geometry.size.width, height: geometry.size.width > geometry.size.height ? geometry.size.height : geometry.size.width * 0.75)
                HStack {
                    Spacer()
                    Text("draw transition path for dancer: ").font(.system(size: 24, design: .default))
                    Picker("Dancer", selection: $dancerTransition) {
                        Text("").tag("AHH")
                        ForEach(formation.dancers, id: \.id) { dancer in
                            Text(dancer.name == "" ? String(dancer.number) : dancer.name)
                                .tag(dancer.id.description)
                        }
                    }
                    
                    Button {
                        if UUID(uuidString: dancerTransition) != nil {
                            drawPath.toggle()
                        }
                        print(dancerTransition)
                    } label: {
                        Text("Go")
                    }
                    .sheet(isPresented: $drawPath) {
                        DrawPathView(formation1: formation, formation2: getNextFormation(), selectedDancer: UUID(uuidString: dancerTransition)!)
                            .environmentObject(formationBook)
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
            }
        }
        .cornerRadius(20)
        .scaledToFit()
        .shadow(radius: 5, x: 0, y: 5)
    }
    
    func getNextFormation() -> FormationModel? {
        for (i, currFormation) in set.formations.enumerated() {
            if currFormation.id == self.formation.id {
                if i < set.formations.count-1 {
                    return set.formations[i+1]
                } else {
                    return nil
                }
            }
        }
        return nil
    }
}

struct FormationView_Previews: PreviewProvider {
    static var previews: some View {
        let dancer1 = DancerModel(number: 1, name: "hello", position: [25.0, 25.0])
        let dancer2 = DancerModel(number: 2, name: "dancer 2", position: [50.0, 50.0])
        let formation = FormationModel(name: "Formation 1", dancers: [dancer1, dancer2], tag: 0)
        FormationView(set: SetModel(name: "asdf", numDancers: 2), formation: formation, pageIndex: .constant(0))
//            .previewInterfaceOrientation(.landscapeLeft)
    }
}
