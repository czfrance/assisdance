//
//  NewSetView.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/5/23.
//

import SwiftUI

struct NewSetView: View {
    
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State private var setname: String = ""
    @State private var dancers: Int = 1
    @State private var createSet = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Set up your new set")
                .font(.system(size: 24, weight: .bold, design: .default))
            
            TextField (
                "Set name",
                text: $setname
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding(.top, 20)
            
            Divider()
            
            HStack {
                Text("Number of Dancers: ")
                Picker("Number of Dancers", selection: $dancers) {
                    ForEach(1...100, id: \.self) { number in
                        Text("\(number)")
                    }
                }
            }
            .padding(.top, 20)
            
            Button {
                createNewSet(name: setname, numDancers: dancers)
                presentationMode.wrappedValue.dismiss()
//                createSet.toggle()
            } label: {
                Text("Create my formations!")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(Color.white)
                    .background(Color.mint)
                    .cornerRadius(10)
            }
//            .sheet(isPresented: $createSet){
//                //Use fullscreen so that we can reset navi stack for sidebar
//                SetView(set: formationBook.createNewSet(name: setname, numDancers: dancers))
//                    .environmentObject(formationBook)
//
//                SetView(set: createNewSet(name: setname, numDancers: dancers))
//                    .environmentObject(formationBook)
//            }
            .padding(.top, 50)
            
        }
        .padding(50)
    }
    
    func createNewSet(name: String, numDancers: Int) {
//        var newSet = formationBook.createNewSet(name: name, numDancers: numDancers)
//        var newSet = SetModel(name: name, numDancers: numDancers)
//        let firstFormation = FormationModel(name: "formation 1")
//        newSet.addFormation(firstFormation)
//        formationBook.addSet(newSet)
        var _ = formationBook.createNewSet(name: name, numDancers: numDancers)
        
//        return newSet
    }
}

struct NewSetView_Previews: PreviewProvider {
    static var previews: some View {
        NewSetView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
