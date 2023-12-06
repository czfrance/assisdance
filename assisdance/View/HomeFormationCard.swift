//
//  HomeFormationCard.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import SwiftUI

struct HomeFormationCard: View {
    
    var set: SetModel
    @EnvironmentObject var formationBook: FormationBookViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "figure.socialdance")
                .font(.system(size: 50, weight: .ultraLight))
                .padding([.leading, .trailing])
                .foregroundColor(Color.mint)
            Text(set.name)
                .font(.system(size: 40))
            Spacer()
        }
        .shadow(radius: 5, x: 0, y: 5)
        .swipeActions {
            Button(role: .destructive){
                formationBook.deletSet(set)
                formationBook.saveSets()
            } label:{
                Label("", systemImage: "trash")
            }
            .tint(.red)
        }
        .cornerRadius(15)
        .padding()
    }
}

struct HomeFormationCard_Previews: PreviewProvider {
    static var previews: some View {
        let set = SetModel(name: "formation 1", numDancers: 5)
        HomeFormationCard(set: set)
    }
}
