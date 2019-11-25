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
    
    var forumsNextPageStartIndex = [Int: Int]() {
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
    var threadsNextPageStartIndex = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    // Comments
    var comments = [Int: Comment]() {
        willSet {
            objectWillChange.send()
        }
    }
    var mainCommentListByThreadId = [Int: [Int]]() {
        willSet {
            objectWillChange.send()
        }
    }
    var childCommentListByParentCommentId = [Int: [Int]]() {
        willSet {
            objectWillChange.send()
        }
    }
    var commentNextPageStartIndex = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    var moreCommentsByParentCommentId = [Int: [Int]]() {
        willSet {
            objectWillChange.send()
        }
    }
    var moreCommentsByThreadId = [Int: [Int]]() {
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
    
    var votes = [Int: Vote]() {
        willSet {
            objectWillChange.send()
        }
    }
    var voteThreadMapping = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    var voteCommentMapping = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    func submitThread(access: String, forumId: Int, title: String, flair: Int, content: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/threads/post_thread_by_game_id/?game_id=" + String(forumId)) else { return }
        
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
                    
                    let tempNewThreadResponse: NewThreadResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    let tempThread = tempNewThreadResponse.threadResponse
                    let vote = tempNewThreadResponse.voteResponse
                    DispatchQueue.main.async {
                        self.threads[tempThread.id] = tempThread
                        self.threadListByGameId[forumId]!.insert(tempThread.id, at: 0)
                        self.mainCommentListByThreadId[tempThread.id] = []
                        self.threadsNextPageStartIndex[tempThread.id] = 0
                        self.votes[vote.id] = vote
                        self.voteThreadMapping[tempThread.id] = vote.id
                    }
                }
            }
        }.resume()
    }
    
    func incrementTreeNodes(node: Comment) {
        var curComment = node
        DispatchQueue.main.async {
            if curComment.parentThread != nil || curComment.parentPost != nil {
                if curComment.parentThread != nil {
                    self.threads[curComment.parentThread!]!.numChilds += 1
                } else {
                    self.comments[curComment.parentPost!]!.numChilds += 1
                }
            }
            
            while curComment.parentThread != nil || curComment.parentPost != nil {
                if curComment.parentThread != nil {
                    self.threads[curComment.parentThread!]!.numSubtreeNodes += 1
                    print("hello", self.threads[curComment.parentThread!]!.numSubtreeNodes)
                    break
                } else {
                    self.comments[curComment.parentPost!]!.numSubtreeNodes += 1
                    curComment = self.comments[curComment.parentPost!]!
                }
            }
        }
    }
    
    func postMainComment(access: String, threadId: Int, text: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/comments/post_comment_by_thread_id/?thread_id=" + String(threadId)) else { return }
        
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
                    let tempNewCommentResponse: NewCommentResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    let tempMainComment = tempNewCommentResponse.commentResponse
                    let tempVote = tempNewCommentResponse.voteResponse
                    DispatchQueue.main.async {
                        self.comments[tempMainComment.id] = tempMainComment
                        self.mainCommentListByThreadId[tempMainComment.parentThread!]!.insert(tempMainComment.id, at: 0)
                        self.threadsNextPageStartIndex[tempMainComment.parentThread!]! += 1
                        self.commentNextPageStartIndex[tempMainComment.id] = 0
                        self.childCommentListByParentCommentId[tempMainComment.id] = []
                        self.incrementTreeNodes(node: tempMainComment)
                        self.votes[tempVote.id] = tempVote
                        
                        self.voteCommentMapping[tempMainComment.id] = tempVote.id
                    }
                }
            }
        }.resume()
    }
    
    func postChildComment(access: String, parentCommentId: Int, text: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/comments/post_comment_by_parent_comment_id/?parent_comment_id=" + String(parentCommentId)) else { return }
        
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
                    let tempNewCommentResponse: NewCommentResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    let tempChildComment = tempNewCommentResponse.commentResponse
                    let tempVote = tempNewCommentResponse.voteResponse
                    DispatchQueue.main.async {
                        self.comments[tempChildComment.id] = tempChildComment
                        self.childCommentListByParentCommentId[tempChildComment.parentPost!]!.insert(tempChildComment.id, at: 0)
                        self.childCommentListByParentCommentId[tempChildComment.id] = [Int]()
                        self.commentNextPageStartIndex[tempChildComment.parentPost!]! += 1
                        self.incrementTreeNodes(node: tempChildComment)
                        self.votes[tempVote.id] = tempVote
                        self.voteCommentMapping[tempChildComment.id] = tempVote.id
                    }
                }
            }
        }.resume()
    }
    
    func fetchCommentTreeByThreadId(access: String, threadId: Int, start:Int = 0, count:Int = 10, size:Int = 50) {
        print("Load comment tree from Thread: ", threadId)
        let params: String = "?parent_thread_id=" + String(threadId) + "&start=" + String(start) + "&count=" + String(count) + "&size=" + String(size)
        
        var roots: String = ""
        if start != 0 {
            for comment_id in self.moreCommentsByThreadId[threadId]! {
                roots += "&roots=" + String(comment_id)
            }
        }

        guard let url = URL(string: "http://127.0.0.1:8000/comments/get_comment_tree_by_thread_id/" + params + roots) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let commentLoadTree: CommentLoadTree = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        if commentLoadTree.addedComments.count == 0 {
                            self.commentNextPageStartIndex[threadId] = -1
                            return
                        }
                        
                        if self.moreCommentsByThreadId[threadId] == nil {
                            self.moreCommentsByThreadId[threadId] = [Int]()
                        }
                        
                        for comment in commentLoadTree.addedComments {
                            if self.comments[comment.id] == nil {
                                self.comments[comment.id] = comment
                                
                                if comment.parentThread != nil {
                                    self.mainCommentListByThreadId[threadId]!.append(comment.id)
                                    self.childCommentListByParentCommentId[comment.id] = [Int]()
                                    self.threadsNextPageStartIndex[threadId]! += 1
                                    self.commentNextPageStartIndex[comment.id] = 0
                                } else {
                                    self.childCommentListByParentCommentId[comment.parentPost!]!.append(comment.id)
                                    self.childCommentListByParentCommentId[comment.id] = [Int]()
                                    self.commentNextPageStartIndex[comment.id] = 1
                                    self.commentNextPageStartIndex[comment.parentPost!]! += 1
                                }
                                self.moreCommentsByParentCommentId[comment.id] = [Int]()
                            } else {
                                self.comments[comment.id] = comment
                            }
                        }
                        
                        self.moreCommentsByThreadId[threadId]! = [Int]()
                        for comment in commentLoadTree.moreComments {
                            if comment.parentThread != nil {
                                self.moreCommentsByThreadId[threadId]!.append(comment.id)
                            } else {
                                self.moreCommentsByParentCommentId[comment.parentPost!]!.append(comment.id)
                            }
                        }
                        
                        for vote in commentLoadTree.addedVotes {
                            self.votes[vote.id] = vote
                            self.voteCommentMapping[vote.comment!] = vote.id
                        }
                    }
                }
            }
        }.resume()
    }
    
    func fetchCommentTreeByParentComment(access: String, parentCommentId: Int, start:Int = 0, count:Int = 10, size:Int = 50) {
        let params: String = "?parent_comment_id=" + String(parentCommentId) + "&start=" + String(start) + "&count=" + String(count) + "&size=" + String(size)
        var roots: String = ""
        for comment_id in self.moreCommentsByParentCommentId[parentCommentId]! {
            roots += "&roots=" + String(comment_id)
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/comments/get_comment_tree_by_parent_comments/" + params + roots) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let commentLoadTree: CommentLoadTree = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        if commentLoadTree.addedComments.count == 0 {
                            self.commentNextPageStartIndex[parentCommentId] = -1
                            return
                        }
                        
                        if self.moreCommentsByParentCommentId[parentCommentId] == nil {
                            self.moreCommentsByParentCommentId[parentCommentId] = [Int]()
                        }
                        
                        for comment in commentLoadTree.addedComments {
                            if self.comments[comment.id] == nil {
                                self.comments[comment.id] = comment
                                self.childCommentListByParentCommentId[parentCommentId]!.append(comment.id)
                                self.childCommentListByParentCommentId[comment.id] = [Int]()
                                self.commentNextPageStartIndex[comment.id] = 0
                                self.commentNextPageStartIndex[comment.parentPost!]! += 1
                                self.moreCommentsByParentCommentId[comment.id] = [Int]()
                            } else {
                                self.comments[comment.id] = comment
                            }
                        }
                        
                        self.moreCommentsByParentCommentId[parentCommentId]! = [Int]()
                        for comment in commentLoadTree.moreComments {
                            self.moreCommentsByParentCommentId[comment.parentPost!]!.append(comment.id)
                        }
                        
                        for vote in commentLoadTree.addedVotes {
                            self.votes[vote.id] = vote
                            self.voteCommentMapping[vote.comment!] = vote.id
                        }
                    }
                }
            }
        }.resume()
    }
    
//    func fetchMainComments(access: String, threadId: Int, start:Int = 0, count:Int = 10) {
//        let params: String = "?thread_id=" + String(threadId) + "&start=" + String(start) + "&count=" + String(count)
//        guard let url = URL(string: "http://127.0.0.1:8000/comments/get_comments_by_thread_id/" + params) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        let sessionConfig = URLSessionConfiguration.default
//        let authString: String? = "Bearer \(access)"
//        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
//        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
//
//        session.dataTask(with: request) { (data, response, error) in
//            if let data = data {
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    let tempPrimaryComments: [Comment] = load(jsonData: jsonString.data(using: .utf8)!)
//                    DispatchQueue.main.async {
//                        if tempPrimaryComments.count == 0 {
//                            self.commentNextPageStartIndex[threadId] = -1
//                            return
//                        }
//
//                        if self.moreCommentsByThreadId[threadId] == nil {
//                            self.moreCommentsByThreadId[threadId] = [Int]()
//                        }
//
//                        for comment in tempPrimaryComments {
//                            if self.comments[comment.id] == nil {
//                                self.comments[comment.id] = comment
//                                self.moreCommentsByThreadId[threadId]!.append(comment.id)
//                            } else {
//                                self.comments[comment.id] = comment
//                            }
//                        }
//
//                        self.commentNextPageStartIndex[threadId] = start + count
//                    }
//                }
//            }
//        }.resume()
//    }
    
    func fetchChildComments(access: String, parentCommentId: Int, start:Int = 0, count:Int = 10) {
        let params: String = "?parent_comment_id=" + String(parentCommentId) + "&start=" + String(start) + "&count=" + String(count)
        guard let url = URL(string: "http://127.0.0.1:8000/comments/get_comments_by_parent_comment_id/" + params) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let tempSecondaryComments: [Comment] = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        if tempSecondaryComments.count == 0 {
                            if self.childCommentListByParentCommentId[parentCommentId] == nil {
                                self.childCommentListByParentCommentId[parentCommentId] = [Int]()
                            }
                            self.commentNextPageStartIndex[parentCommentId] = -1
                            return
                        }

                        for comment in tempSecondaryComments {
                            if self.comments[comment.id] == nil {
                                self.comments[comment.id] = comment
                                self.childCommentListByParentCommentId[parentCommentId]!.append(comment.id)
                                self.childCommentListByParentCommentId[comment.id] = [Int]()
                            } else {
                                self.comments[comment.id] = comment
                            }
                        }
                        
                        self.commentNextPageStartIndex[parentCommentId] = start + count
                    }
                }
            }
        }.resume()
    }
    
    func fetchThreads(access: String, game: Game, start:Int = 0, count:Int = 10) {
        let params: String = "?game=" + String(game.id) + "&start=" + String(start) + "&count=" + String(count)
        guard let url = URL(string: "http://127.0.0.1:8000/threads/get_threads_by_game_id/" + params) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let tempThreadsResponse: ThreadsResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        if self.threadListByGameId[game.id] == nil {
                             self.threadListByGameId[game.id] = [Int]()
                        }
                        
                        if tempThreadsResponse.threadsResponse.count == 0 && self.forumsNextPageStartIndex[game.id] == nil {
                            self.forumsNextPageStartIndex[game.id] = -1
                            return
                        }
                        
                        for thread in tempThreadsResponse.threadsResponse {
                            if self.threads[thread.id] == nil {
                                self.threads[thread.id] = thread
                                self.mainCommentListByThreadId[thread.id] = [Int]()
                                self.threadListByGameId[game.id]!.append(thread.id)
                                self.threadsNextPageStartIndex[thread.id] = 0
                            } else {
                                self.threads[thread.id] = thread
                            }
                        }
                        
                        if tempThreadsResponse.hasNextPage == true {
                            self.forumsNextPageStartIndex[game.id] = start + count
                        } else {
                            self.forumsNextPageStartIndex[game.id] = -1
                        }
                        
                        for vote in tempThreadsResponse.votesResponse {
                            self.votes[vote.id] = vote
                            self.voteThreadMapping[vote.thread!] = vote.id
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
            print("---- WAITING FOR GAMES AND GENRE ------")
            taskGroup.notify(queue: .main) {
                print("----- NOTIFIED - LOADED GAMES AND GENRE -----")
                print(self.genreGameArray)
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
                        
                        print("I'm done fetching genres", self.genres, self.genreGameArray)
                        taskGroup.leave()
                    }
                }
            }
        }.resume()
    }
    
    func fetchFollowGames(access: String, userDataStore: UserDataStore, start:Int = 0, count:Int = 10) {
        if self.games.count != 0 {
            return
        }
        
        let params: String = "?start=" + String(start) + "&count=" + String(count)
        guard let url = URL(string: "http://127.0.0.1:8000/games/get_followed_games_by_user_id/" + params) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let followGames: [Game] = load(jsonData: jsonString.data(using: .utf8)!)
                    var followedGamesTempArr = [Int]()
                    DispatchQueue.main.async {
                        for game in followGames {
                            self.isFollowed[game.id] = true
                            followedGamesTempArr.append(game.id)
                            if self.games[game.id] == nil {
                                self.games[game.id] = game
                                self.threadListByGameId[game.id] = [Int]()
                            }
                        }
                        
                        self.followedGames = followedGamesTempArr
                    }
                }
            }
        }.resume()
    }
    
    func fetchAllGames(access: String, userDataStore: UserDataStore, taskGroup: DispatchGroup, start:Int = 0, count:Int = 10) {
        
        let params: String = "?start=" + String(start) + "&count=" + String(count)
        guard let url = URL(string: "http://127.0.0.1:8000/games/" + params) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let tempGames: [Game] = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        for game in tempGames {
                            if self.isFollowed[game.id] == nil {
                                self.isFollowed[game.id] = false
                            }
                            self.games[game.id] = game
                        }
                        print("I am done fetching games", self.games)
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
    
    func upvoteThread(access: String, thread: Thread) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/upvote_by_thread_id/") else { return }
        let json: [String: Any] = ["thread_id": thread.id]
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
                    let newVote: Vote = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.votes[newVote.id] = newVote
                        self.voteThreadMapping[thread.id] = newVote.id
                        self.threads[thread.id]!.upvotes += 1
                    }
                }
            }
        }.resume()
    }
    
    func switchUpvoteThread(access: String, thread: Thread) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/downvote_to_upvote_by_thread_id/") else { return }
        let json: [String: Any] = ["vote_id": voteThreadMapping[thread.id]!]
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
                    let newVote: Vote = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.votes[newVote.id] = newVote
                        self.voteThreadMapping[thread.id] = newVote.id
                        self.threads[thread.id]!.upvotes += 1
                        self.threads[thread.id]!.downvotes -= 1
                        
                        print(self.threads[thread.id]!.upvotes)
                        print(self.threads[thread.id]!.downvotes)
                    }
                }
            }
        }.resume()
    }
    
    func downvoteThread(access: String, thread: Thread) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/downvote_by_thread_id/") else { return }
        let json: [String: Any] = ["thread_id": thread.id]
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
                    let newVote: Vote = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.votes[newVote.id] = newVote
                        self.voteThreadMapping[thread.id] = newVote.id
                        self.threads[thread.id]!.downvotes += 1
                    }
                }
            }
        }.resume()
    }
    
    func switchDownvoteThread(access: String, thread: Thread) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/upvote_to_downvote_by_thread_id/") else { return }
        let json: [String: Any] = ["vote_id": voteThreadMapping[thread.id]!]
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
                    let newVote: Vote = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.votes[newVote.id] = newVote
                        self.voteThreadMapping[thread.id] = newVote.id
                        self.threads[thread.id]!.upvotes -= 1
                        self.threads[thread.id]!.downvotes += 1
                    }
                }
            }
        }.resume()
    }
    
    func upvoteComment(access: String, comment: Comment) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/upvote_by_comment_id/") else { return }
        let json: [String: Any] = ["comment_id": comment.id]
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
                    let newVote: Vote = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.votes[newVote.id] = newVote
                        self.voteCommentMapping[comment.id] = newVote.id
                        self.comments[comment.id]!.upvotes += 1
                    }
                }
            }
        }.resume()
    }
    
    func switchUpvoteComment(access: String, comment: Comment) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/downvote_to_upvote_by_comment_id/") else { return }
        let json: [String: Any] = ["vote_id": voteCommentMapping[comment.id]!]
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
                    let newVote: Vote = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.votes[newVote.id] = newVote
                        self.voteCommentMapping[comment.id] = newVote.id
                        self.comments[comment.id]!.upvotes += 1
                        self.comments[comment.id]!.downvotes -= 1
                    }
                }
            }
        }.resume()
    }
    
    func downvoteComment(access: String, comment: Comment) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/downvote_by_comment_id/") else { return }
        let json: [String: Any] = ["comment_id": comment.id]
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
                    let newVote: Vote = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.votes[newVote.id] = newVote
                        self.voteCommentMapping[comment.id] = newVote.id
                        self.comments[comment.id]!.downvotes += 1
                    }
                }
            }
        }.resume()
    }
    
    func switchDownvoteComment(access: String, comment: Comment) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/upvote_to_downvote_by_comment_id/") else { return }
        let json: [String: Any] = ["vote_id": voteCommentMapping[comment.id]!]
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
                    let newVote: Vote = load(jsonData: jsonString.data(using: .utf8)!)
                    DispatchQueue.main.async {
                        self.votes[newVote.id] = newVote
                        self.voteCommentMapping[comment.id] = newVote.id
                        self.comments[comment.id]!.upvotes -= 1
                        self.comments[comment.id]!.downvotes += 1
                    }
                }
            }
        }.resume()
    }
    
    func deleteCommentVote(access: String, vote: Vote) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/delete_vote_by_vote_id_comment/") else { return }
        
        let json: [String: Any] = ["vote_id": vote.id]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    if vote.isPositive == true {
                        self.comments[vote.comment!]!.upvotes -= 1
                    } else {
                        self.comments[vote.comment!]!.downvotes -= 1
                    }
                    
                    self.voteCommentMapping.removeValue(forKey: vote.comment!)
                    self.votes.removeValue(forKey: vote.id)
                    
                }
            }
        }.resume()
    }
    
    func deleteThreadVote(access: String, vote: Vote) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/delete_vote_by_vote_id_thread/") else { return }
        let json: [String: Any] = ["vote_id": vote.id]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    if vote.isPositive == true {
                        self.threads[vote.thread!]!.upvotes -= 1
                    } else {
                        self.threads[vote.thread!]!.downvotes -= 1
                    }
                    
                    self.voteThreadMapping.removeValue(forKey: vote.thread!)
                    self.votes.removeValue(forKey: vote.id)
                }
            }
        }.resume()
    }
    
    
}

