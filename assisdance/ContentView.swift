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
            RootScreen()
                .environmentObject(Auth.shared)
        }
        .padding()
    }
}
//profric
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
