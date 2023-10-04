//
//  Auth.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation
//import SwiftKeychainWrapper

class Auth: ObservableObject {
    
    static let shared: Auth = Auth()
//    private let keychain: KeychainWrapper = KeychainWrapper.standard
    
    @Published var loggedIn: Bool = false
    
    private init() {
//        loggedIn = hasAccessToken()
        loggedIn = false
    }
    
//    func getCredentials() -> Credentials {
//        return Credentials(
//            accessToken: keychain.string(forKey: KeychainKey.accessToken.rawValue),
//            refreshToken: keychain.string(forKey: KeychainKey.refreshToken.rawValue)
//        )
//    }
//
//    func setCredentials(accessToken: String, refreshToken: String) {
//        keychain.set(accessToken, forKey: KeychainKey.accessToken.rawValue)
//        keychain.set(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
//
//        loggedIn = true
//    }
//
//    func hasAccessToken() -> Bool {
//        return getCredentials().accessToken != nil
//    }
//
//    func getAccessToken() -> String? {
//        return getCredentials().accessToken
//    }
//
//    func getRefreshToken() -> String? {
//        return getCredentials().refreshToken
//    }
    
    func login() {
        loggedIn = true
    }

    func logout() {
//        KeychainWrapper.standard.removeObject(forKey: KeychainKey.accessToken.rawValue)
//        KeychainWrapper.standard.removeObject(forKey: KeychainKey.refreshToken.rawValue)
        loggedIn = false
    }
    
}
