//
//  LoginView.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import SwiftUI

struct LoginScreen: View {
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Login")
                    .font(.system(size: 24, weight: .bold, design: .default))
                TextField(
                    "Login.UsernameField.Title".localized,
                    text: $viewModel.username
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                
                SecureField(
                    "Login.PasswordField.Title".localized,
                    text: $viewModel.password
                )
                .padding(.top, 20)
                
                Divider()
            }
            Spacer()
            
            Button(
                action: viewModel.login,
                label: {
                    Text("Login.LoginButton.Title".localized)
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .foregroundColor(Color.white)
                        .background(Color.mint)
                        .cornerRadius(10)
                }
            )
        }
        .padding(30)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
