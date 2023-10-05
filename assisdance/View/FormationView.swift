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
                Image("defaultSetImage")
            }
        }
        .cornerRadius(20)
        .scaledToFit()
        .shadow(radius: 5, x: 0, y: 5)
    }
}

struct FormationView_Previews: PreviewProvider {
    static var previews: some View {
        let formation = FormationModel(name: "Formation 1")
        FormationView(formation: formation)
    }
}
