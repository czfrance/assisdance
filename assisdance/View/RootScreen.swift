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
                    let tempSet1 = SetModel(name: "Example Set 1")
                    let tempSet2 = SetModel(name: "Example Set 2")
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
    }
}
