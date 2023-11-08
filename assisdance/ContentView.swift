//
//  ContentView.swift
//  assisdance
//
//  Created by Cynthia Z France on 9/6/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        VStack {
//            RootScreen()
//                .environmentObject(Auth.shared)
//        }
//        .padding()
//        DrawingView()
        VStack {
            DrawingView()
            ZStack {
                DancerIcon(posx: 0.0, posy: 0.0)
                DancerIcon(posx: 100.0, posy: 100.0)
            }
        }
    }
}
//profric
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
