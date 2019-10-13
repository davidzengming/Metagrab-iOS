//
//  UserDataStore.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class UserDataStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var username: String?
    var password: String?
    var token: Token?
    var accessToken: Token?
    
    func login(username: String, password: String) {
        self.username = username
        self.password = password
        self.acquireToken()
    }
    
    func refreshToken(queryGroup: DispatchGroup) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/token/refresh") else { return }
        var request = URLRequest(url: url)
        let bodyData = "refresh=\(self.token!.refresh)"
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.accessToken = load(jsonData: jsonString.data(using: .utf8)!)
                        self.token!.access = self.accessToken!.access
                        queryGroup.leave()
                    }
                }
            }
        }.resume()
    }
    
    func acquireToken() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/token/") else { return }
        var request = URLRequest(url: url)

        let bodyData = "username=\(self.username!)&password=\(self.password!)"
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.token = load(jsonData: jsonString.data(using: .utf8)!)
                        print(self.token!.access)
                        self.objectWillChange.send()
                    }
                }
            }
        }.resume()
    }
    
    func register(username: String, password: String, email: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/users/") else { return }
        var request = URLRequest(url: url)
        
        let bodyData = "username=\(username)&password=\(password)&email=\(email)"
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if String(data: data, encoding: .utf8) != nil {
                    DispatchQueue.main.async {
                        let data = String(bytes: data, encoding: String.Encoding.utf8)
                        self.username = username
                        self.password = password
                        self.acquireToken()
                    }
                }
            }
        }.resume()
    }
}
