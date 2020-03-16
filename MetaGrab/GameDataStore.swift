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
import Cloudinary

final class GameDataStore: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "dzengcdn", apiKey: "348513889264333", secure: true))
    
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
    
    var gameBannerImage = [Int: UIImage]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var gamesByYear = [Int: [Int: [Int:Set<Int>]]]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var sortedDaysListByMonthYear = [Int: [Int: [Int]]]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var sortedGamesListByDayMonthYear = [Int: [Int: [Int: [Int]]]]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isBackToGamesView: Bool = true {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isFirstFetchAllGames: Bool = true {
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
    var threadsIndexInGameList = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    var isLoadingNextPageInForum = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var threadsDesiredHeight = [Int: CGFloat]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var threadsImages = [Int: [UIImage]]() {
        willSet {
            objectWillChange.send()
        }
    }
    var threadsTextStorage = [Int: NSTextStorage]() {
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
    var commentsTextStorage = [Int: NSTextStorage]() {
        willSet {
            objectWillChange.send()
        }
    }
    var commentsDesiredHeight = [Int: CGFloat]() {
        willSet {
            objectWillChange.send()
        }
    }
    var visibleChildCommentsNum = [Int: Int]() {
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
    
    // Users
    var users = [Int: User]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var attributesEncodingCache: [Int: Any] = [:]
    func generateTextStorageFromJson(isThread: Bool, id: Int) -> NSTextStorage {
        let generatedTextStorage = NSTextStorage(string: isThread ? self.threads[id]!.contentString : self.comments[id]!.contentString)
        
        for attribute in isThread ? self.threads[id]!.contentAttributes.attributes : self.comments[id]!.contentAttributes.attributes {
            let encode = attribute[0]
            let location = attribute[1]
            let length = attribute[2]
            
            if attributesEncodingCache[encode] != nil {
                generatedTextStorage.addAttributes(attributesEncodingCache[encode] as! [NSAttributedString.Key : Any], range: NSMakeRange(location, length))
            } else {
                let attributesToBeApplied = TextViewHelper.generateAttributesFromEncoding(encode: encode)
                generatedTextStorage.addAttributes(attributesToBeApplied, range: NSMakeRange(location, length))
                attributesEncodingCache[encode] = attributesToBeApplied
            }
        }
        return generatedTextStorage
    }
    
    func submitThread(access: String, forumId: Int, title: String, flair: Int, content: NSTextStorage, imageData: [UUID: Data], imagesArray: [UUID]) {
        let taskGroup = DispatchGroup()
        
        var imageUrls : [String] = []
        
        if imagesArray.count != 0 {
            for id in imagesArray {
                if imageData[id] == nil {
                    continue
                }
                
                taskGroup.enter()
                let preprocessChain = CLDImagePreprocessChain()
                    .addStep(CLDPreprocessHelpers.limit(width: 500, height: 500))
                    .addStep(CLDPreprocessHelpers.dimensionsValidator(minWidth: 10, maxWidth: 500, minHeight: 10, maxHeight: 500))
                _ = cloudinary.createUploader().upload(data: imageData[id]!, uploadPreset: "cyr1nlwn", preprocessChain: preprocessChain)
                    .response({response, error in
                        if error == nil {
                            imageUrls.append(response!.secureUrl!)
                            taskGroup.leave()
                        }
                    })
            }
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/threads/post_thread_by_game_id/?game_id=" + String(forumId)) else { return }
        
        taskGroup.notify(queue: DispatchQueue.global()) {
            let json: [String: Any] = ["title": title, "content_string": content.string, "content_attributes": ["attributes": TextViewHelper.parseTextStorageAttributesAsBitRep(content: content)], "flair": flair, "image_urls": ["urls": imageUrls]]
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            let sessionConfig = URLSessionConfiguration.default
            let authString: String? = "Bearer \(access)"
            sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
            let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
            
            session.dataTask(with: request) {(data, response, error) in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        let tempNewThreadResponse: NewThreadResponse = load(jsonData: jsonString.data(using: .utf8)!)
                        let tempThread = tempNewThreadResponse.threadResponse
                        let vote = tempNewThreadResponse.voteResponse
                        let user = tempNewThreadResponse.userResponse
                        
                        DispatchQueue.main.async {
                            self.users[user.id] = user
                            self.threads[tempThread.id] = tempThread
                            self.threadsDesiredHeight[tempThread.id] = 0
                            self.mainCommentListByThreadId[tempThread.id] = []
                            self.threadsNextPageStartIndex[tempThread.id] = 0
                            self.votes[vote.id] = vote
                            self.voteThreadMapping[tempThread.id] = vote.id
                            self.threadsTextStorage[tempThread.id] = content
                            
                            self.threadListByGameId[forumId]!.insert(tempThread.id, at: 0)
                            
                            for id in imagesArray {
                                if imageData[id] != nil {
                                    self.threadsImages[tempThread.id]!.append(UIImage(data: imageData[id]!)!)
                                }
                            }
                        }
                    }
                }
            }.resume()
        }
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
                    break
                } else {
                    self.comments[curComment.parentPost!]!.numSubtreeNodes += 1
                    curComment = self.comments[curComment.parentPost!]!
                }
            }
        }
    }
    
    func postMainComment(access: String, threadId: Int, content: NSTextStorage) {
        guard let url = URL(string: "http://127.0.0.1:8000/comments/post_comment_by_thread_id/?thread_id=" + String(threadId)) else { return }
        
        let json: [String: Any] = ["content_string": content.string, "content_attributes": ["attributes": TextViewHelper.parseTextStorageAttributesAsBitRep(content: content)]]
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
                    let user = tempNewCommentResponse.userResponse
                    
                    DispatchQueue.main.async {
                        self.users[user.id] = user
                        self.comments[tempMainComment.id] = tempMainComment
                        self.commentsTextStorage[tempMainComment.id] = content
                        self.commentsDesiredHeight[tempMainComment.id] = 0
                        self.threadsNextPageStartIndex[tempMainComment.parentThread!]! += 1
                        self.commentNextPageStartIndex[tempMainComment.id] = 0
                        self.childCommentListByParentCommentId[tempMainComment.id] = []
                        self.incrementTreeNodes(node: tempMainComment)
                        self.votes[tempVote.id] = tempVote
                        self.voteCommentMapping[tempMainComment.id] = tempVote.id
                        
                        self.mainCommentListByThreadId[tempMainComment.parentThread!]!.insert(tempMainComment.id, at: 0)
                    }
                }
            }
        }.resume()
    }
    
    func postChildComment(access: String, parentCommentId: Int, content: NSTextStorage) {
        guard let url = URL(string: "http://127.0.0.1:8000/comments/post_comment_by_parent_comment_id/?parent_comment_id=" + String(parentCommentId)) else { return }
        
        let json: [String: Any] = ["content_string": content.string, "content_attributes": ["attributes": TextViewHelper.parseTextStorageAttributesAsBitRep(content: content)]]
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
                    let user = tempNewCommentResponse.userResponse
                    
                    DispatchQueue.main.async {
                        self.users[user.id] = user
                        self.comments[tempChildComment.id] = tempChildComment
                        self.commentsTextStorage[tempChildComment.id] = content
                        self.commentsDesiredHeight[tempChildComment.id] = 0
                        self.childCommentListByParentCommentId[tempChildComment.id] = [Int]()
                        
                        if self.commentNextPageStartIndex[tempChildComment.parentPost!]! != -1 {
                            self.commentNextPageStartIndex[tempChildComment.parentPost!]! += 1
                        }
                        
                        self.incrementTreeNodes(node: tempChildComment)
                        self.votes[tempVote.id] = tempVote
                        self.voteCommentMapping[tempChildComment.id] = tempVote.id
                        
                        self.visibleChildCommentsNum[tempChildComment.parentPost!]! += 1
                        self.commentNextPageStartIndex[tempChildComment.id] = -1
                        self.childCommentListByParentCommentId[tempChildComment.parentPost!]!.insert(tempChildComment.id, at: 0)
                    }
                }
            }
        }.resume()
    }
    
    func fetchCommentTreeByThreadId(access: String, threadId: Int, start:Int = 0, count:Int = 10, size:Int = 50, refresh: Bool = false) {
        if refresh == true {
            DispatchQueue.main.async {
                self.mainCommentListByThreadId[threadId] = [Int]()
                self.threadsNextPageStartIndex[threadId] = 0
                self.moreCommentsByThreadId[threadId] = [Int]()
            }
        }
        
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
                        
                        var commentListToBeAppendedToThread : [Int] = []
                        var commentListToBeAppendedToComment : [Int: [Int]] = [:]
                        
                        for comment in commentLoadTree.addedComments {
                            self.comments[comment.id] = comment
                            
                            if comment.parentThread != nil {
                                commentListToBeAppendedToThread.append(comment.id)
                                self.childCommentListByParentCommentId[comment.id] = [Int]()
                                self.threadsNextPageStartIndex[threadId]! += 1
                                self.commentNextPageStartIndex[comment.id] = 0
                                self.visibleChildCommentsNum[comment.id] = 0
                            } else {
                                if commentListToBeAppendedToComment[comment.parentPost!] == nil {
                                    commentListToBeAppendedToComment[comment.parentPost!] = []
                                }
                                commentListToBeAppendedToComment[comment.parentPost!]!.append(comment.id)
                                self.visibleChildCommentsNum[comment.parentPost!]! += 1
                                self.visibleChildCommentsNum[comment.id] = 0
                                
                                self.childCommentListByParentCommentId[comment.id] = [Int]()
                                self.commentNextPageStartIndex[comment.id] = 0
                                self.commentNextPageStartIndex[comment.parentPost!]! += 1
                            }
                            
                            self.commentsTextStorage[comment.id] = self.generateTextStorageFromJson(isThread: false, id: comment.id)
                            
                            if self.commentsDesiredHeight[comment.id] == nil {
                                self.commentsDesiredHeight[comment.id] = 0
                            }
                            
                            self.moreCommentsByParentCommentId[comment.id] = [Int]()
                        }
                        
                        for (parentComment, childComments) in commentListToBeAppendedToComment {
                            self.childCommentListByParentCommentId[parentComment]! = childComments
                        }
                        self.mainCommentListByThreadId[threadId]! += commentListToBeAppendedToThread
                        
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
                        
                        for user in commentLoadTree.usersResponse {
                            self.users[user.id] = user
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
                            self.comments[comment.id] = comment
                            self.childCommentListByParentCommentId[parentCommentId]!.append(comment.id)
                            self.childCommentListByParentCommentId[comment.id] = [Int]()
                            self.commentNextPageStartIndex[comment.id] = 0
                            self.commentNextPageStartIndex[comment.parentPost!]! += 1
                            self.commentsTextStorage[comment.id] = self.generateTextStorageFromJson(isThread: false, id: comment.id)
                            
                            if self.commentsDesiredHeight[comment.id] == nil {
                                self.commentsDesiredHeight[comment.id] = 0
                            }
                            
                            self.visibleChildCommentsNum[comment.parentPost!]! += 1
                            self.visibleChildCommentsNum[comment.id] = 0
                            
                            self.moreCommentsByParentCommentId[comment.id] = [Int]()
                        }
                        
                        self.moreCommentsByParentCommentId[parentCommentId]! = [Int]()
                        for comment in commentLoadTree.moreComments {
                            self.moreCommentsByParentCommentId[comment.parentPost!]!.append(comment.id)
                        }
                        
                        for vote in commentLoadTree.addedVotes {
                            self.votes[vote.id] = vote
                            self.voteCommentMapping[vote.comment!] = vote.id
                        }
                        
                        for user in commentLoadTree.usersResponse {
                            self.users[user.id] = user
                        }
                    }
                }
            }
        }.resume()
    }
    
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
    
    func fetchThreads(access: String, game: Game, start:Int = 0, count:Int = 10, refresh: Bool = false) {
        
        DispatchQueue.main.async {
            if refresh == true {
                self.threadListByGameId[game.id] = [Int]()
                self.forumsNextPageStartIndex[game.id] = nil
            }
        }
        
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
                        
                        var newThreadsList: [Int] = []
                        for thread in tempThreadsResponse.threadsResponse {
                            newThreadsList.append(thread.id)
                            self.threads[thread.id] = thread
                            self.mainCommentListByThreadId[thread.id] = [Int]()
                            self.threadsIndexInGameList[thread.id] = self.threadListByGameId[game.id]!.count - 1
                            self.threadsNextPageStartIndex[thread.id] = 0
                            self.threadsTextStorage[thread.id] = self.generateTextStorageFromJson(isThread: true, id: thread.id)
                            
                            if self.threadsDesiredHeight[thread.id] == nil {
                                self.threadsDesiredHeight[thread.id] = 0
                            }
                        }
                        
                        self.threadListByGameId[game.id]! += newThreadsList
                        
                        if tempThreadsResponse.hasNextPage == true {
                            self.forumsNextPageStartIndex[game.id] = start + count
                        } else {
                            self.forumsNextPageStartIndex[game.id] = -1
                        }
                        
                        for vote in tempThreadsResponse.votesResponse {
                            self.votes[vote.id] = vote
                            self.voteThreadMapping[vote.thread!] = vote.id
                        }
                        
                        for user in tempThreadsResponse.usersResponse {
                            self.users[user.id] = user
                        }
                        
                        self.isLoadingNextPageInForum[game.id] = false
                    }
                }
            }
        }.resume()
    }
    
    func loadThreadIcons(thread: Thread) {
        if threadsImages[thread.id] != nil || thread.imageUrls.urls.count == 0 {
            return
        }
        
        self.threadsImages[thread.id] = []
        for imageURL in thread.imageUrls.urls {
            URLSession.shared.dataTask(with: URL(string: imageURL)!) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.threadsImages[thread.id]!.append(UIImage(data: data)!)
                }
            }.resume()
        }
    }
    
    func loadGameBanner(game: Game) {
        if gameBannerImage[game.id] != nil || game.banner == "" {
            return
        }
        
        guard let imageURL = URL(string: game.banner) else {
            fatalError("ImageURL is not correct!")
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.gameBannerImage[game.id] = UIImage(data: data)
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
        taskGroup.enter()
        self.fetchGenres(access: access, userDataStore: userDataStore, taskGroup: taskGroup)
        taskGroup.enter()
        self.fetchAllGames(access: access, userDataStore: userDataStore, taskGroup: taskGroup)
        
        print("---- WAITING FOR GAMES AND GENRE ------")
        taskGroup.notify(queue: .global()) {
            print("----- NOTIFIED - LOADED GAMES AND GENRE -----")
            print(self.genreGameArray)
            var tempGenreGameArray = self.genreGameArray
            for (game_id, game) in self.games {
                let genreIndex = game.genre.id
                tempGenreGameArray[genreIndex]!.append(game_id)
            }
            
            DispatchQueue.main.async {
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
                        print("----- Done fetching genres----- ", self.genres, self.genreGameArray)
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
                                self.isLoadingNextPageInForum[game.id] = false
                                self.threadListByGameId[game.id] = [Int]()
                            }
                        }
                        
                        self.followedGames = followedGamesTempArr
                    }
                }
            }
        }.resume()
    }
    
    func fetchRecentAndUpcomingGames(access: String, userDataStore: UserDataStore, beforeMonths: Int = 2, afterYear: Int = 1) {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        let startMonth = (month - beforeMonths) % 12
        let startYear = (month - beforeMonths) >= 0 ? year : year - 1
        let endMonth = month
        let endYear = year + afterYear
        
        let params: String = "?start_month=" + String(startMonth) + "&start_year=" + String(startYear) + "&end_month=" + String(endMonth) + "&end_year" + String(endYear)
        guard let url = URL(string: "http://127.0.0.1:8000/games/get_recent_games/" + params) else { return }
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
                    }
                }
            }
        }.resume()
    }
    
    func fetchAllGames(access: String, userDataStore: UserDataStore, taskGroup: DispatchGroup, start:Int = 0, count:Int = 10) {
        let params: String = "?start=" + String(start) + "&count=" + String(count)
        guard let url = URL(string: "http://127.0.0.1:8000/games/get_recent_games/" + params) else { return }
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
                    let calendar = Calendar.current
                    
                    DispatchQueue.main.async {
                        for game in tempGames {
                            if self.isFollowed[game.id] == nil {
                                self.isFollowed[game.id] = false
                            }
                            self.games[game.id] = game
                            
                            if self.threadListByGameId[game.id] == nil {
                                self.threadListByGameId[game.id] = [Int]()
                            }
                            
                            var releaseYear = calendar.component(.year, from: game.releaseDate)
                            var releaseMonth = calendar.component(.month, from: game.releaseDate)
                            var releaseDay = calendar.component(.day, from: game.releaseDate)
                            
                            if game.nextExpansionReleaseDate != nil {
                                releaseYear = calendar.component(.year, from: game.nextExpansionReleaseDate!)
                                releaseMonth = calendar.component(.month, from: game.nextExpansionReleaseDate!)
                                releaseDay = calendar.component(.day, from: game.nextExpansionReleaseDate!)
                            }
                            
                            if self.gamesByYear[releaseYear] == nil {
                                self.gamesByYear[releaseYear] = [Int:[Int: Set<Int>]]()
                            }
                            
                            if self.gamesByYear[releaseYear]![releaseMonth] == nil {
                                self.gamesByYear[releaseYear]![releaseMonth] = [Int: Set<Int>]()
                            }
                            
                            if self.gamesByYear[releaseYear]![releaseMonth]![releaseDay] == nil {
                                self.gamesByYear[releaseYear]![releaseMonth]![releaseDay] = Set<Int>()
                            }
                            
                            self.gamesByYear[releaseYear]![releaseMonth]![releaseDay]!.insert(game.id)
                        }
                        
                        
                        for (year, _) in self.gamesByYear {
                            for (month, _) in self.gamesByYear[year]! {
                                if self.sortedDaysListByMonthYear[year] == nil {
                                    self.sortedDaysListByMonthYear[year] = [:]
                                }
                                
                                self.sortedDaysListByMonthYear[year]![month] = Array(self.gamesByYear[year]![month]!.keys).sorted{$0 < $1}
                                
                                for (day, _) in self.gamesByYear[year]![month]! {
                                    
                                    if self.sortedGamesListByDayMonthYear[year] == nil {
                                        self.sortedGamesListByDayMonthYear[year] = [:]
                                    }
                                    
                                    if self.sortedGamesListByDayMonthYear[year]![month] == nil {
                                        self.sortedGamesListByDayMonthYear[year]![month] = [:]
                                    }
                                    
                                    self.sortedGamesListByDayMonthYear[year]![month]![day] = Array(self.gamesByYear[year]![month]![day]!).sorted()
                                }
                            }
                        }
                        
                        print("----- Done fetching games ----- ", self.games)
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
    
    func upvoteByExistingVoteIdThread(access: String, voteId: Int, thread: Thread) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/upvote_by_vote_id/") else { return }
        let json: [String: Any] = ["vote_id": voteId]
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
                    self.threads[thread.id]!.upvotes += 1
                    self.votes[voteId]!.direction = 1
                }
            }
        }.resume()
    }
    
    func downvoteByExistingVoteIdThread(access: String, voteId: Int, thread: Thread) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/downvote_by_vote_id/") else { return }
        let json: [String: Any] = ["vote_id": voteId]
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
                    self.threads[thread.id]!.downvotes += 1
                    self.votes[voteId]!.direction = -1
                }
            }
        }.resume()
    }
    
    func upvoteByExistingVoteIdComment(access: String, voteId: Int, comment: Comment) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/upvote_by_vote_id/") else { return }
        let json: [String: Any] = ["vote_id": voteId]
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
                    self.comments[comment.id]!.upvotes += 1
                    self.votes[voteId]!.direction = 1
                }
            }
        }.resume()
    }
    
    func downvoteByExistingVoteIdComment(access: String, voteId: Int, comment: Comment) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/downvote_by_vote_id/") else { return }
        let json: [String: Any] = ["vote_id": voteId]
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
                    self.comments[comment.id]!.downvotes += 1
                    self.votes[voteId]!.direction = -1
                }
            }
        }.resume()
    }
    
    func addNewUpvoteThread(access: String, thread: Thread) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/add_new_upvote_by_thread_id/") else { return }
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
            if error == nil {
                DispatchQueue.main.async {
                    self.votes[self.voteThreadMapping[thread.id]!]!.direction = 1
                    self.threads[thread.id]!.upvotes += 1
                    self.threads[thread.id]!.downvotes -= 1
                }
            }
        }.resume()
    }
    
    func addNewDownvoteThread(access: String, thread: Thread) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/add_new_downvote_by_thread_id/") else { return }
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
            if error == nil {
                DispatchQueue.main.async {
                    self.votes[self.voteThreadMapping[thread.id]!]!.direction = -1
                    self.threads[thread.id]!.upvotes -= 1
                    self.threads[thread.id]!.downvotes += 1
                }
            }
            
        }.resume()
    }
    
    func addNewUpvoteComment(access: String, comment: Comment) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/add_new_upvote_by_comment_id/") else { return }
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
            if error == nil {
                DispatchQueue.main.async {
                    self.votes[self.voteCommentMapping[comment.id]!]!.direction = 1
                    self.comments[comment.id]!.upvotes += 1
                    self.comments[comment.id]!.downvotes -= 1
                }
            }
        }.resume()
    }
    
    func addNewDownvoteComment(access: String, comment: Comment) {
        guard let url = URL(string: "http://127.0.0.1:8000/votes/add_new_downvote_by_comment_id/") else { return }
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
            if error == nil {
                DispatchQueue.main.async {
                    self.votes[self.voteCommentMapping[comment.id]!]!.direction = -1
                    self.comments[comment.id]!.upvotes -= 1
                    self.comments[comment.id]!.downvotes += 1
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
                    if vote.direction == 1 {
                        self.comments[vote.comment!]!.upvotes -= 1
                    } else {
                        self.comments[vote.comment!]!.downvotes -= 1
                    }
                    
                    self.votes[vote.id]!.direction = 0
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
                    if vote.direction == 1 {
                        self.threads[vote.thread!]!.upvotes -= 1
                    } else {
                        self.threads[vote.thread!]!.downvotes -= 1
                    }
                    
                    self.votes[vote.id]!.direction = 0
                }
            }
        }.resume()
    }
}

