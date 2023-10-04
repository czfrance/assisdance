//
//  HomeViewModel.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

class HomeViewModel: ObservableObject {

    func logout() {
        print("logged out!")
        Auth.shared.logout()
    }
}
