//
//  ContentView.swift
//  assisdance
//
//  Created by Cynthia Z France on 9/6/23.
//

import SwiftUI
import MessageUI

struct ContentView: View {
    var body: some View {
        VStack {
            RootScreen()
                .environmentObject(Auth.shared)
        }
        .padding()
    }
//    @State var result: Result<MFMailComposeResult, Error>? = nil
//   @State var isShowingMailView = false
//
//    var body: some View {
//        Button(action: {
//            print("tapped")
//            self.isShowingMailView.toggle()
//        }) {
//            Text("Tap Me")
//        }
//        .disabled(!MFMailComposeViewController.canSendMail())
//        .sheet(isPresented: $isShowingMailView) {
//            MailView(result: self.$result)
//        }
//    }
}
//profric
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
