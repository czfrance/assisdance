//
//  LoginResponse.swift
//  assisdance
//
//  Created by Cynthia Z France on 10/4/23.
//

import Foundation

struct LoginResponse: Decodable {
    let data: LoginResponseData
}

struct LoginResponseData: Decodable {
    let accessToken: String
    let refreshToken: String
}
