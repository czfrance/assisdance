//
//  RootScreen.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import SwiftUI

struct RootScreen: View {
    @EnvironmentObject var auth: Auth
    
    var body: some View {
        if auth.loggedIn {
            HomeScreen()
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
