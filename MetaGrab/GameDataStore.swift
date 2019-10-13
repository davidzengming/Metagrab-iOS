//
//  GameDataStore.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class GameDataStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // Game and Icon States
    var games = [Int: Game]() {
        willSet {
            objectWillChange.send()
        }
    }
    var gameIcons = [Int: UIImage]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    // Threads
    var threads = [Int: Thread]() {
        willSet {
            objectWillChange.send()
        }
    }
    var threadListByGameId = [Int: [Int]]() {
        willSet {
            objectWillChange.send()
        }
    }
    var threadCursorByForumId = [Int: String]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    // Primary Comments
    var primaryComments = [Int: PrimaryComment]() {
        willSet {
            objectWillChange.send()
        }
    }
    var primaryCommentListByThreadId = [Int: [Int]]() {
        willSet {
            objectWillChange.send()
        }
    }
    var primaryCommentsCursorByThreadId = [Int: String]() {
        willSet {
            objectWillChange.send()
        }
    }

    
    // Secondary Comments
    var secondaryComments = [Int: SecondaryComment]() {
        willSet {
            objectWillChange.send()
        }
    }
    var secondaryCommentListByPrimeCommentId = [Int: [Int]]() {
        willSet {
            objectWillChange.send()
        }
    }
    var secondaryCommentsCursorByPrimaryCommentId = [Int: String]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    // Follow Game States
    var followedGames = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    var genres = [Int: Genre]() {
        willSet {
            objectWillChange.send()
        }
    }
    var genreGameArray = [Int: [Int]]() {
        willSet {
            objectWillChange.send()
        }
    }
    var isFollowed = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    func submitThread(access: String, forumId: Int, title: String, flair: String, content: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/forums/\(forumId)/post_thread_by_forum_id/") else { return }
        
        let json: [String: Any] = ["title": title, "content": content, "flair": flair]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    var tempThread: Thread
                    tempThread = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.threads[tempThread.id] = tempThread
                        self.threadListByGameId[forumId]!.insert(tempThread.id, at: 0)
                        self.primaryCommentListByThreadId[tempThread.id] = []
                    }
                }
            }
        }.resume()
    }
    
    func postPrimaryComment(access: String, threadId: Int, text: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/threads/\(threadId)/post_comment_by_thread_id/") else { return }
        
        let json: [String: Any] = ["content": text]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    var tempPrimaryComment: PrimaryComment
                    tempPrimaryComment = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.primaryComments[tempPrimaryComment.id] = tempPrimaryComment
                        self.primaryCommentListByThreadId[tempPrimaryComment.parentThread]!.insert(tempPrimaryComment.id, at: 0)
                        self.secondaryCommentListByPrimeCommentId[tempPrimaryComment.id] = []
                    }
                }
            }
        }.resume()
    }
    
    func postSecondaryComment(access: String, primaryCommentId: Int, text: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/comments/\(primaryCommentId)/post_comment_by_primary_comment_id/") else { return }
        
        let json: [String: Any] = ["content": text]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    var tempSecondaryComment: SecondaryComment
                    tempSecondaryComment = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.secondaryComments[tempSecondaryComment.id] = tempSecondaryComment
                        self.secondaryCommentListByPrimeCommentId[tempSecondaryComment.parentPost]!.insert(tempSecondaryComment.id, at: 0)
                    }
                }
            }
        }.resume()
    }
    
    func fetchPrimaryComments(access: String, threadId: Int, fetchNextPage: Bool = false) {
        
        guard let url = URL(string: fetchNextPage ? primaryCommentsCursorByThreadId[threadId]! : "http://127.0.0.1:8000/threads/\(threadId)/get_comments_by_thread_id/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let tempPrimaryCommentsPage: PrimaryCommentsPage = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        if self.primaryCommentListByThreadId[threadId] == nil {
                             self.primaryCommentListByThreadId[threadId] = [Int]()
                         }
                        
                        for comment in tempPrimaryCommentsPage.results {
                            if self.primaryComments[comment.id] == nil {
                                self.primaryComments[comment.id] = comment
                                self.primaryCommentListByThreadId[threadId]!.append(comment.id)
                                self.secondaryCommentListByPrimeCommentId[comment.id] = [Int]()
                            } else {
                                self.primaryComments[comment.id] = comment
                            }
                        }
                        
                        if tempPrimaryCommentsPage.next != nil {
                            self.primaryCommentsCursorByThreadId[threadId] = tempPrimaryCommentsPage.next!
                        } else {
                            self.primaryCommentsCursorByThreadId[threadId] = nil
                        }
                    }
                }
            }
        }.resume()
    }
    
    func fetchSecondaryComments(access: String, primaryCommentId: Int, fetchNextPage: Bool = false) {
        guard let url = URL(string: fetchNextPage ? secondaryCommentsCursorByPrimaryCommentId[primaryCommentId]! : "http://127.0.0.1:8000/comments/\(primaryCommentId)/get_comments_by_primary_comment_id/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let tempSecondaryCommentsPage: SecondaryCommentsPage = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        if self.secondaryCommentListByPrimeCommentId[primaryCommentId] == nil {
                             self.secondaryCommentListByPrimeCommentId[primaryCommentId] = [Int]()
                         }
                        
                        for comment in tempSecondaryCommentsPage.results {
                            if self.secondaryComments[comment.id] == nil {
                                self.secondaryComments[comment.id] = comment
                                self.secondaryCommentListByPrimeCommentId[primaryCommentId]!.append(comment.id)
                            } else {
                                self.secondaryComments[comment.id] = comment
                            }
                        }
                        
                        if tempSecondaryCommentsPage.next != nil {
                                                    self.secondaryCommentsCursorByPrimaryCommentId[primaryCommentId] = tempSecondaryCommentsPage.next!
                        } else {
                            self.secondaryCommentsCursorByPrimaryCommentId[primaryCommentId] = nil
                        }
                    }
                }
            }
        }.resume()
    }
    
    func fetchThreads(access: String, game: Game, fetchNextPage: Bool = false) {
        guard let url = URL(string: fetchNextPage ? threadCursorByForumId[game.id]! : "http://127.0.0.1:8000/threads/get_threads_by_game_id/?game=" + String(game.id)) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let tempThreadsPage: ThreadsPage = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        if self.threadListByGameId[game.id] == nil {
                             self.threadListByGameId[game.id] = [Int]()
                         }
                        
                        for thread in tempThreadsPage.results {
                            if self.threads[thread.id] == nil {
                                self.threads[thread.id] = thread
                                self.primaryCommentListByThreadId[thread.id] = [Int]()
                                self.threadListByGameId[game.id]!.append(thread.id)
                            } else {
                                self.threads[thread.id] = thread
                            }
                        }
                        
                        if tempThreadsPage.next != nil {
                            self.threadCursorByForumId[game.id] = tempThreadsPage.next!
                        } else {
                            self.threadCursorByForumId[game.id] = nil
                        }
                    }
                }
            }
        }.resume()
    }
    
    
    func loadGameIcon(game: Game) {
        if gameIcons[game.id] != nil {
            return
        }
        
        guard let imageURL = URL(string: game.icon) else {
            fatalError("ImageURL is not correct!")
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.gameIcons[game.id] = UIImage(data: data)
            }
        }.resume()
    }
    
    func fetchAndSortGamesWithGenre(access: String, userDataStore: UserDataStore) {
        let taskGroup = DispatchGroup()
        
        DispatchQueue.main.async {
            taskGroup.enter()
        }
        self.fetchGenres(access: access, userDataStore: userDataStore, taskGroup: taskGroup)
        DispatchQueue.main.async {
            taskGroup.enter()
        }
        self.fetchAllGames(access: access, userDataStore: userDataStore, taskGroup: taskGroup)
        
        DispatchQueue.main.async {
            taskGroup.notify(queue: .main) {
                var tempGenreGameArray = self.genreGameArray
                for (game_id, game) in self.games {
                    let genreIndex = game.genre.id
                    tempGenreGameArray[genreIndex]!.append(game_id)
                }
                
                self.genreGameArray = tempGenreGameArray
            }
        }
    }
    
    func fetchGenres(access: String, userDataStore: UserDataStore, taskGroup: DispatchGroup) {
        guard let url = URL(string: "http://127.0.0.1:8000/genre") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    var tempGenres = [Genre]()
                    tempGenres = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        for genre in tempGenres {
                            self.genres[genre.id] = genre
                            self.genreGameArray[genre.id] = [Int]()
                        }
                        taskGroup.leave()
                    }
                }
            }
        }.resume()
    }
    
    func fetchFollowGames(access: String, userDataStore: UserDataStore) {
        if self.games.count != 0 {
            return
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/games/get_followed_games_by_user_id/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let followGamesPage: GamesPage = load(jsonData: jsonString.data(using: .utf8)!)
                    var followedGamesTempArr = [Int]()
                    DispatchQueue.main.async {
                        for game in followGamesPage.results {
                            self.isFollowed[game.id] = true
                            followedGamesTempArr.append(game.id)
                            if self.games[game.id] == nil {
                                self.games[game.id] = game
                            }
                        }
                        
                        self.followedGames = followedGamesTempArr
                    }
                }
            }
        }.resume()
    }
    
    func fetchAllGames(access: String, userDataStore: UserDataStore, taskGroup: DispatchGroup) {
        guard let url = URL(string: "http://127.0.0.1:8000/games/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    
                    let tempGamesPage: GamesPage = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        for game in tempGamesPage.results {
                            if self.isFollowed[game.id] == nil {
                                self.isFollowed[game.id] = false
                            }
                            self.games[game.id] = game
                        }
                        taskGroup.leave()
                    }
                }
            }
        }.resume()
    }
    
    func followGame(access: String, game: Game) {
        guard let url = URL(string: "http://127.0.0.1:8000/games/\(game.id)/follow_game_by_game_id/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        session.dataTask(with: request) { (data, response, error) in    
            if error == nil {
                DispatchQueue.main.async {
                    self.isFollowed[game.id] = true
                    self.followedGames.append(game.id)
                }
            }
        }.resume()
    }
    
    func unfollowGame(access: String, game: Game) {
        guard let url = URL(string: "http://127.0.0.1:8000/games/\(game.id)/unfollow_game_by_game_id/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.isFollowed[game.id] = false
                    if let index = self.followedGames.firstIndex(of: game.id) {
                        self.followedGames.remove(at: index)
                    }
                }
            }
        }.resume()
    }
}

