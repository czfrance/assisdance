//
//  FormationView.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/5/23.
//

import SwiftUI

struct FormationView: View {
    
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State var formation: FormationModel
    
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
                SingleFormationView(formation: formation)
            }
        }
        .cornerRadius(20)
        .scaledToFit()
        .shadow(radius: 5, x: 0, y: 5)
    }
}

struct FormationView_Previews: PreviewProvider {
    static var previews: some View {
        let dancer1 = DancerModel(position: [25.0, 25.0])
        let dancer2 = DancerModel(position: [50.0, 50.0])
        let formation = FormationModel(name: "Formation 1", dancers: [dancer1, dancer2])
        FormationView(formation: formation)
    }
}
