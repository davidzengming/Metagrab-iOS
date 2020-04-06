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
    
    var username: String? = nil {
        willSet {
            objectWillChange.send()
        }
    }
    var password: String? = nil {
        willSet {
            objectWillChange.send()
        }
    }
    var token: Token? = nil {
        willSet {
            objectWillChange.send()
        }
    }
    var isAuthenticated: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    func onStart() {
        if let usernameData = KeyChain.load(key: "metagrabusername"), let passwordData = KeyChain.load(key: "metagrabpassword"), let tokenaccessData = KeyChain.load(key: "metagrabtokenaccess"), let tokenrefreshData = KeyChain.load(key: "metagrabtokenrefresh"), let userId = KeyChain.load(key: "userid") {
            self.username = String(data: usernameData, encoding: String.Encoding.utf8) as String?
            self.password = String(data: passwordData, encoding: String.Encoding.utf8) as String?
            self.token = Token(refresh: String(data: tokenrefreshData, encoding: String.Encoding.utf8)!, access: String(data: tokenaccessData, encoding: String.Encoding.utf8)!, userId: Int(String(data: userId, encoding: String.Encoding.utf8)!)!)
        }
    }
    
    func autologin() {
        acquireToken()
    }
    
    func login(username: String, password: String) {
        self.username = username
        self.password = password
        
        let taskGroup = DispatchGroup()
        taskGroup.enter()
        self.acquireToken(taskGroup: taskGroup)
        
        taskGroup.notify(queue: DispatchQueue.global()) {
            print("saved to keychain credentials")
            let status1 = KeyChain.save(key: "metagrabusername", data: username.data(using: String.Encoding.utf8)!)
            let status2 = KeyChain.save(key: "metagrabpassword", data: password.data(using: String.Encoding.utf8)!)
            let status3 = KeyChain.save(key: "metagrabtokenaccess", data: self.token!.access.data(using: String.Encoding.utf8)!)
            let status4 = KeyChain.save(key: "metagrabtokenrefresh", data: self.token!.refresh.data(using: String.Encoding.utf8)!)
            let status5 = KeyChain.save(key: "userid", data: String(self.token!.userId).data(using: String.Encoding.utf8)!)
        }
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
                        self.token!.access = load(jsonData: jsonString.data(using: .utf8)!)
                        queryGroup.leave()
                    }
                }
            }
        }.resume()
    }
    
    func acquireToken(taskGroup: DispatchGroup? = nil) {
        guard let url = URL(string: "http://127.0.0.1:8000/api/token/") else { return }
        var request = URLRequest(url: url)
        
        let bodyData = "username=\(self.username!)&password=\(self.password!)"
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    
                    print(jsonString, "test")
                    DispatchQueue.main.async {
                        self.token = load(jsonData: jsonString.data(using: .utf8)!)
                        self.isAuthenticated = true
                        self.objectWillChange.send()
                        if taskGroup != nil {
                            taskGroup!.leave()
                        }
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
                        //let data = String(bytes: data, encoding: String.Encoding.utf8)
                        self.username = username
                        self.password = password
                        self.acquireToken()
                    }
                }
            }
        }.resume()
    }
}
