//
//  RootScreen.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import SwiftUI

struct RootScreen: View {
    @EnvironmentObject var auth: Auth
    @StateObject private var formationBook = FormationBookViewModel()
    
    var body: some View {
        if auth.loggedIn {
            HomeScreen()
                .environmentObject(formationBook)
                .onAppear {
                    formationBook.loadSets()
                    var tempSet1 = SetModel(name: "Example Set 1", numDancers: 5)
                    var tempSet2 = SetModel(name: "Example Set 2", numDancers: 6)
                    let formation1 = FormationModel(name: "formation 1")
                    let formation2 = FormationModel(name: "formation 2")
                    let formation3 = FormationModel(name: "formation 3")
                    let formation4 = FormationModel(name: "formation 4")
                    tempSet1.addFormation(formation1)
                    tempSet1.addFormation(formation2)
                    tempSet2.addFormation(formation3)
                    tempSet2.addFormation(formation4)
                    formationBook.addSet(tempSet1)
                    formationBook.addSet(tempSet2)
                }
        } else {
            LoginScreen()
        }
    }
}

struct RootScreen_Previews: PreviewProvider {
    static var previews: some View {
        RootScreen()
            .environmentObject(Auth.shared)
    }
}
