//
//  APICall.swift
//  assisdance
//
//  Created by Cynthia Z France on 11/30/23.
//

import Foundation

func makePostRequest(body: Any) {
//    guard let url = URL(string: "https://jasonplaceholder.typicode.com/posts") else {
//        return
//    }
    guard let url = URL(string: "http://127.0.0.1:5000/calc") else {
        return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("SUCCESS: \(response)")
        } catch {
            print("errorrr: \(error)")
        }
    }
    task.resume()
    
    
    /*
     const response = await fetch("http://127.0.0.1:5000/register", {
         credentials: "include",
         method: "POST",
         headers: {
             "Content-Type": "application/json",
         },
         body: JSON.stringify(user_info),
     })
     */
}

func makeGetRequest() {
    guard let url = URL(string: "http://127.0.0.1:5000/test_get") else {
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: AnyHashable] = [
        "userId": 1,
        "title": "hello this is a test!",
        "body": "body body body test"
    ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    let task = URLSession.shared.dataTask(with: request) { data, urlResponse, error in
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print("SUCCESS: \(response)")
        } catch {
            print("errorrr: \(error)")
        }
    }
    task.resume()
    
    
    /*
     const response = await fetch("http://127.0.0.1:5000/register", {
         credentials: "include",
         method: "POST",
         headers: {
             "Content-Type": "application/json",
         },
         body: JSON.stringify(user_info),
     })
     */
}
