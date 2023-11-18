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
//            set.image
//                .resizable()
//                .frame(width: 100, height: 100)
//                .padding(.leading, 25)
            Text(set.name)
                .font(.system(size: 28))
            Spacer()
        }
    }
}

struct HomeFormationCard_Previews: PreviewProvider {
    static var previews: some View {
        let set = SetModel(name: "formation 1", numDancers: 5)
//        let set = SetViewModel(setModel: setModel)
        HomeFormationCard(set: set)
    }
}
