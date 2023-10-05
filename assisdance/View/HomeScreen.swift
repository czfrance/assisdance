//
//  HomeScreen.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    @EnvironmentObject var formationBook: FormationBookViewModel
    @State private var newSet = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("Home.Title".localized)
                .font(.system(size: 24, weight: .bold, design: .default))

            NavigationStack {
                List(formationBook.sets) { danceSet in
                    NavigationLink {
                        SetView(set: danceSet)
                    } label: {
                        HomeFormationCard(set: danceSet)
                    }
                }
                .navigationTitle("Your Sets")
                
                Button {
                    newSet.toggle()
                } label: {
                    Text("Create new Set")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(Color.mint)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $newSet){
                    //Use fullscreen so that we can reset navi stack for sidebar
                    NewSetView()
                        .environmentObject(formationBook)
                }
            }
        
            Button(
                action: viewModel.logout,
                label: {
                    Text("Home.LogoutButton.Title".localized)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            )
        }
        .padding(30)
    }
}

struct HomeScreen_Previews_wrapper : View {
    
    func preview(formationBook: FormationBookViewModel) -> FormationBookViewModel {
        let set1 = SetModel(name: "set 1", numDancers: 5)
        let set2 = SetModel(name: "set 2", numDancers: 6)
        formationBook.addSet(set1)
        formationBook.addSet(set2)
        
        return formationBook
    }
    
    var body: some View {
        HomeScreen()
            .environmentObject(preview(formationBook: FormationBookViewModel()))
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen_Previews_wrapper()
    }
}
