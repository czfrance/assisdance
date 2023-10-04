//
//  ContentView.swift
//  assisdance
//
//  Created by Cynthia Z France on 9/6/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("ContentView.WelcomeMessage".localized(arguments: "Peter"))
            RootScreen()
                .environmentObject(Auth.shared)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
