//
//  LoginViewModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

class LoginViewModel: ObservableObject {

    @Published var username: String = ""
    @Published var password: String = ""

    func login() {
        print("logged in!")
        Auth.shared.login()
//        LoginAction(
//            parameters: LoginRequest(
//                username: username,
//                password: password
//            )
//        ).call { response in
//            print("login success")
//            // Login successful, navigate to the Home screen
//        }
    }
}
