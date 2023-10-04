//
//  HomeScreen.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import SwiftUI

struct HomeScreen: View {
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Home.Title".localized)
                .font(.system(size: 24, weight: .bold, design: .default))
            
            Spacer()
            
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

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
