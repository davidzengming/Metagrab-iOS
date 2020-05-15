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
    
    var lastClickedReportThreadByForumId = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var lastClickedReportCommentByThreadId = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isLastClickedReportThreadInThreadViewByThreadId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isReportPopupActiveByForumId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isReportPopupActiveByThreadId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var blacklistedUserIdArr = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var lastClickedBlockUserByForumId = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var lastClickedBlockUserByThreadId = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isBlockPopupActiveByForumId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isBlockPopupActiveByThreadId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var hiddenThreadIdArr = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var hiddenCommentIdArr = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var blacklistedUsersById = [Int: User]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var hiddenThreadsById = [Int: Thread]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var hiddenCommentsById = [Int: Comment]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isUserBlockedByUserId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isThreadHiddenByThreadId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isCommentHiddenByCommentId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var myGameVisitHistory = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var myGameVisitHistorySet = Set<Int>() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var colors = [String: Color]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var uiColors = [String: UIColor]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var leadingLineColors = [Color]() {
        willSet {
            objectWillChange.send()
        }
    }
    
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
    
    var isInModalView: Bool = false {
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
    
    var hasGameByYear = [Int: Bool]() {
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
    
    var isForumViewLoadedByGameId = [Int: Bool]() {
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
    
    var threadImagesHeight = [Int: CGFloat]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var threadsTextStorage = [Int: NSTextStorage]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var threadViewReplyBarDesiredHeight = [Int: CGFloat]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isReplyBarReplyingToThreadByThreadId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var replyTargetCommentIdByThreadId = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var relativeDateStringByThreadId = [Int: String]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isThreadViewLoadedByThreadId = [Int: Bool]() {
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
    
    var relativeDateStringByCommentId = [Int: String]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    // Keyboard state
    var keyboardHeight: CGFloat = 0 {
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
    
    let emojiNames = [
        ":thumbs_up:",
        ":thumbs_down:",
        ":tongue_out:",
        ":sweat:",
        ":sunglasses:",
        ":laugh_out_loud:",
        ":hearts:",
        ":ecks_dee:",
        ":ecks_dee_tongue:",
        ":cry:",
        ":belgium:",
        ":lemon:"
    ]
    
    // Emojis
    let maxEmojisPerThread = 10
    let maxEmojisPerComment = 10
    
    var emojis = [Int: UIImage]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var emojiArray = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var emojiArrByThreadId = [Int: [[Int]]]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    //    var emojiArrByCommentId = [Int: [[Int]]]() {
    //        willSet {
    //            objectWillChange.send()
    //        }
    //    }
    
    var emojiCountByThreadId = [Int: [Int: Int]]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    //    var emojiCountByCommentId = [Int: [Int: Int]]() {
    //        willSet {
    //            objectWillChange.send()
    //        }
    //    }
    
    var otherUsersArrReactToEmojiByThreadId = [Int: [Int: [Int]]]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    //    var otherUsersArrReactToEmojiByCommentId = [Int: [Int: [Int]]]() {
    //        willSet {
    //            objectWillChange.send()
    //        }
    //    }
    //
    var otherUsersSetReactToEmojiByThreadId = [Int: [Int: Set<Int>]]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    //    var otherUsersSetReactToEmojiByCommentId = [Int: [Int: Set<Int>]]() {
    //        willSet {
    //            objectWillChange.send()
    //        }
    //    }
    
    var didReactToEmojiByThreadId = [Int: [Int: Bool]]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    //    var didReactToEmojiByCommentId = [Int: [Int: Bool]]() {
    //        willSet {
    //            objectWillChange.send()
    //        }
    //    }
    
    var isAddEmojiModalActiveByForumId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isAddEmojiModalActiveByThreadViewId = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var addEmojiViewLastClickedIsThread = [Int: Bool]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var addEmojiThreadIdByForumId = [Int: Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    //    var addEmojiCommentIdByThreadId = [Int: Int]() {
    //        willSet {
    //            objectWillChange.send()
    //        }
    //    }
    
    var voteCountStringByCommentId = [Int: String]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func loadLeadingLineColors() {
        if self.leadingLineColors.count != 0 {
            return
        }
        
        var leadingLineColors : [Color] = []
        leadingLineColors.append(Color.purple)
        leadingLineColors.append(Color.red)
        leadingLineColors.append(Color.orange)
        leadingLineColors.append(Color.yellow)
        leadingLineColors.append(Color.green)
        self.leadingLineColors = leadingLineColors
        return
    }
    
    func loadColors() {
        if self.colors.count != 0 {
            return
        }
        
        self.colors["notQuiteBlack"] = Color(hexStringToUIColor(hex: "#23272a"))
        self.colors["darkButNotBlack"] = Color(hexStringToUIColor(hex: "#2C2F33"))
        self.colors["blurple"] = Color(hexStringToUIColor(hex: "#7289DA"))
        
        self.uiColors["notQuiteBlack"] = hexStringToUIColor(hex: "#23272a")
        self.uiColors["darkButNotBlack"] = hexStringToUIColor(hex: "#2C2F33")
        self.uiColors["blurple"] = hexStringToUIColor(hex: "#7289DA")
    }
    
    func loadEmojis() {
        emojiArray = []
        
        for index in (0..<emojiNames.count) {
            emojis[index] = UIImage(named: emojiNames[index])
            emojiArray.append(index)
        }
    }
    
    func isEmojiVote(emojiId: Int) -> Bool {
        return emojiId == 0 || emojiId == 1
    }
    
    let maxEmojiCountPerRow = 5
    
    func getInitialEmojiArray(emojiArr: [Int], threadId: Int?, commentId: Int?) -> [[Int]] {
        
        var res = [[Int]]()
        res.append([])
        
        for emojiId in emojiArr {
            let row = res.count - 1
            let col = res[row].count
            
            if col == self.maxEmojiCountPerRow {
                res.append([emojiId])
                continue
            }
            res[res.count - 1].append(emojiId)
        }
        
        // add plus emoji button
        if res.count <= 2 && res[res.count - 1].count < self.maxEmojiCountPerRow {
            res[res.count - 1].append(999)
        } else if res.count == 1 && res[res.count - 1].count == self.maxEmojiCountPerRow {
            res.append([999])
        }
        
        return res
    }
    
    func getShiftedArrayForAddEmoji(emojiId: Int, threadId: Int?, commentId: Int?) -> [[Int]] {
        let arr = self.emojiArrByThreadId[threadId!]!
        
        //        let arr = threadId != nil ? self.emojiArrByThreadId[threadId!]! : self.emojiArrByCommentId[commentId!]!
        var res = [[Int]]()
        
        if emojiId == 0 {
            res.append([emojiId])
            
            for i in 0 ..< arr.count {
                for j in 0 ..< arr[i].count {
                    let arrRow = res.count - 1
                    let arrCol = res[arrRow].count
                    
                    if arrRow == 1 && arrCol == self.maxEmojiCountPerRow {
                        break
                    }
                    
                    if arrCol == self.maxEmojiCountPerRow {
                        res.append([arr[i][j]])
                        continue
                    }
                    
                    res[res.count - 1].append(arr[i][j])
                }
            }
        } else if emojiId == 1 {
            //            if (threadId != nil ? self.emojiCountByThreadId[threadId!]![0] != nil : self.emojiCountByCommentId[commentId!]![0]! != nil) {
            
            if (self.emojiCountByThreadId[threadId!]![0] != nil) {
                res.append([0, 1])
                for i in 0 ..< arr.count {
                    for j in 0 ..< arr[i].count {
                        let arrRow = res.count - 1
                        let arrCol = res[arrRow].count
                        
                        if arrRow == 1 && arrCol == self.maxEmojiCountPerRow {
                            break
                        }
                        
                        if arr[i][j] == 0 {
                            continue
                        }
                        
                        if arrCol == self.maxEmojiCountPerRow {
                            res.append([arr[i][j]])
                            continue
                        }
                        res[res.count - 1].append(arr[i][j])
                    }
                }
            } else {
                res.append([1])
                for i in 0 ..< arr.count {
                    for j in 0 ..< arr[i].count {
                        let arrRow = res.count - 1
                        let arrCol = res[arrRow].count
                        
                        if arrRow == 1 && arrCol == self.maxEmojiCountPerRow {
                            break
                        }
                        
                        if arrCol == self.maxEmojiCountPerRow {
                            res.append([arr[i][j]])
                            continue
                        }
                        res[res.count - 1].append(arr[i][j])
                    }
                }
            }
            
        } else {
            res = arr
            
            let arrRow = res.count - 1
            let arrCol = res[arrRow].count
            
            res[res.count - 1].popLast()
            res[res.count - 1].append(emojiId)
            
            if arrRow == 1 && arrCol == self.maxEmojiCountPerRow {
                return res
            }
            
            if arrCol == self.maxEmojiCountPerRow {
                res.append([999])
            } else {
                res[res.count - 1].append(999)
            }
        }
        
        return res
    }
    
    func getShiftedArrayForRemoveEmoji(emojiId: Int, threadId: Int?, commentId: Int?) -> [[Int]] {
        let arr = self.emojiArrByThreadId[threadId!]!
        //        let arr = threadId != nil ? self.emojiArrByThreadId[threadId!]! : self.emojiArrByCommentId[commentId!]!
        
        var res = [[Int]]()
        res.append([])
        
        var isLastElementAddEmoji = true
        if arr.count == 2 && arr[arr.count - 1].count == self.maxEmojiCountPerRow && arr[arr.count - 1][self.maxEmojiCountPerRow - 1] != 999 {
            isLastElementAddEmoji = false
        }
        
        for i in 0 ..< arr.count {
            for j in 0 ..< arr[i].count {
                let arrRow = res.count - 1
                let arrCol = res[arrRow].count
                
                if arr[i][j] == emojiId {
                    continue
                }
                
                if arrCol == maxEmojiCountPerRow {
                    res.append([arr[i][j]])
                    continue
                }
                res[res.count - 1].append(arr[i][j])
            }
        }
        
        if isLastElementAddEmoji == false {
            res[res.count - 1].append(999)
        }
        
        return res
    }
    
    func addEmojiToStore(emojiId: Int, threadId: Int?, commentId: Int?, userId: Int, newEmojiCount: Int) {
        DispatchQueue.main.async {
            if threadId != nil {
                var emojiAlreadyExists = false
                
                if self.emojiCountByThreadId[threadId!]![emojiId] != nil {
                    emojiAlreadyExists = true
                }
                
                self.emojiCountByThreadId[threadId!]![emojiId] = newEmojiCount
                
                self.didReactToEmojiByThreadId[threadId!]![emojiId] = true
                
                if self.otherUsersSetReactToEmojiByThreadId[threadId!]![emojiId] == nil {
                    self.otherUsersSetReactToEmojiByThreadId[threadId!]![emojiId] = []
                }
                
                self.otherUsersSetReactToEmojiByThreadId[threadId!]![emojiId]!.insert(userId)
                
                if emojiAlreadyExists == true {
                    print("Emoji already exists in array, not adding a new icon.")
                    return
                }
                
                self.emojiArrByThreadId[threadId!]! = self.getShiftedArrayForAddEmoji(emojiId: emojiId, threadId: threadId, commentId: commentId)
            } else {
                
                //                var emojiAlreadyExists = false
                //                if self.emojiCountByCommentId[commentId!]![emojiId] != nil {
                //                    emojiAlreadyExists = true
                //                }
                //
                //                self.emojiCountByCommentId[commentId!]![emojiId] = newEmojiCount
                //
                //                self.didReactToEmojiByCommentId[commentId!]![emojiId] = true
                //
                //                if self.otherUsersSetReactToEmojiByCommentId[commentId!]![emojiId] == nil {
                //                    self.otherUsersSetReactToEmojiByCommentId[commentId!]![emojiId] = []
                //                }
                //
                //                self.otherUsersSetReactToEmojiByCommentId[commentId!]![emojiId]!.insert(userId)
                //
                //                if emojiAlreadyExists == true {
                //                    print("Emoji already exists in array, not adding a new icon.")
                //                    return
                //                }
                //                self.emojiArrByCommentId[commentId!]! = self.getShiftedArrayForAddEmoji(emojiId: emojiId, threadId: threadId, commentId: commentId)
            }
        }
    }
    
    func removeEmojiFromStore(emojiId: Int, threadId: Int?, commentId: Int?, userId: Int, newEmojiCount: Int) {
        DispatchQueue.main.async {
            if threadId != nil {
                if newEmojiCount == 0 {
                    self.emojiArrByThreadId[threadId!] = self.getShiftedArrayForRemoveEmoji(emojiId: emojiId, threadId: threadId, commentId: commentId)
                    self.didReactToEmojiByThreadId[threadId!]!.removeValue(forKey: emojiId)
                    self.emojiCountByThreadId[threadId!]!.removeValue(forKey: emojiId)
                } else {
                    self.didReactToEmojiByThreadId[threadId!]![emojiId] = false
                    self.emojiCountByThreadId[threadId!]![emojiId] = newEmojiCount
                }
            } else {
                //                if newEmojiCount == 0 {
                //                    self.emojiArrByCommentId[commentId!] = self.getShiftedArrayForRemoveEmoji(emojiId: emojiId, threadId: threadId, commentId: commentId)
                //                    self.emojiCountByCommentId[commentId!]!.removeValue(forKey: emojiId)
                //                    self.didReactToEmojiByCommentId[commentId!]!.removeValue(forKey: emojiId)
                //                } else {
                //                    self.didReactToEmojiByCommentId[commentId!]![emojiId] = false
                //                    self.emojiCountByCommentId[commentId!]![emojiId] = newEmojiCount
                //                }
            }
        }
    }
    
    func addEmojiByThreadId(access: String, threadId: Int,  emojiId: Int, userId: Int) {
        
        if self.didReactToEmojiByThreadId[threadId]![emojiId] != nil && self.didReactToEmojiByThreadId[threadId]![emojiId]! == true {
            print("Already reacted with same emoji.")
            return
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/emojis/add_new_emoji_by_thread_id/") else { return }
        let json: [String: Any] = ["thread_id": threadId, "emoji_id": emojiId]
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
                    let emojiResponse: EmojiResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    if emojiResponse.isSuccess == false {
                        return
                    }
                    
                    self.addEmojiToStore(emojiId: emojiId, threadId: threadId, commentId: nil, userId: userId, newEmojiCount: emojiResponse.newEmojiCount)
                }
            }
        }.resume()
    }
    
//    func addEmojiByCommentId(access: String, commentId: Int,  emojiId: Int, userId: Int) {
//        if self.didReactToEmojiByCommentId[commentId]![emojiId] != nil && self.didReactToEmojiByCommentId[commentId]![emojiId]! == true {
//            print("Already reacted with same emoji.")
//            return
//        }
//
//        guard let url = URL(string: "http://127.0.0.1:8000/emojis/add_new_emoji_by_comment_id/") else { return }
//        let json: [String: Any] = ["comment_id": commentId, "emoji_id": emojiId]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//
//        let sessionConfig = URLSessionConfiguration.default
//        let authString: String? = "Bearer \(access)"
//        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
//        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
//
//        session.dataTask(with: request) { (data, response, error) in
//            if let data = data {
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    let emojiResponse: EmojiResponse = load(jsonData: jsonString.data(using: .utf8)!)
//
//                    if emojiResponse.isSuccess == false {
//                        return
//                    }
//
//                    self.addEmojiToStore(emojiId: emojiId, threadId: nil, commentId: commentId, userId: userId, newEmojiCount: emojiResponse.newEmojiCount)
//                }
//            }
//        }.resume()
//    }
    
    // Only thread and comment authors can delete
    func removeEmojiByThreadId(access: String, threadId: Int,  emojiId: Int, userId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/emojis/remove_emoji_by_thread_id/") else { return }
        let json: [String: Any] = ["thread_id": threadId, "emoji_id": emojiId]
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
                    let emojiResponse: EmojiResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    if emojiResponse.isSuccess == false {
                        return
                    }
                    
                    self.removeEmojiFromStore(emojiId: emojiId, threadId: threadId, commentId: nil, userId: userId, newEmojiCount: emojiResponse.newEmojiCount)
                }
            }
        }.resume()
    }
    
//    func removeEmojiByCommentId(access: String, commentId: Int,  emojiId: Int, userId: Int) {
//        guard let url = URL(string: "http://127.0.0.1:8000/emojis/remove_emoji_by_comment_id/") else { return }
//        let json: [String: Any] = ["comment_id": commentId, "emoji_id": emojiId]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//
//        let sessionConfig = URLSessionConfiguration.default
//        let authString: String? = "Bearer \(access)"
//        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
//        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
//
//        session.dataTask(with: request) { (data, response, error) in
//            if let data = data {
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    let emojiResponse: EmojiResponse = load(jsonData: jsonString.data(using: .utf8)!)
//
//                    if emojiResponse.isSuccess == false {
//                        return
//                    }
//
//                    self.removeEmojiFromStore(emojiId: emojiId, threadId: nil, commentId: commentId, userId: userId, newEmojiCount: emojiResponse.newEmojiCount)
//                }
//            }
//        }.resume()
//    }
    
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
    
    func sendReportByThreadId(access: String, threadId: Int, reason: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/reports/add_report_by_thread_id/") else { return }
        
        let json: [String: Any] = ["thread_id": threadId, "report_reason": reason]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
        }.resume()
    }
    
    func sendReportByCommentId(access: String, commentId: Int, reason: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/reports/add_report_by_comment_id/") else { return }
        
        let json: [String: Any] = ["comment_id": commentId, "report_reason": reason]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
        }.resume()
    }
    
    func hideThread(access: String, threadId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/users_profile/hide_thread_by_user_id/") else { return }
        
        let json: [String: Any] = ["hide_thread_id": threadId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                self.hiddenThreadIdArr.append(threadId)
                self.hiddenThreadsById[threadId] = self.threads[threadId]
                self.isThreadHiddenByThreadId[threadId] = true
            }
        }.resume()
    }
    
    func unhideThread(access: String, threadId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/users_profile/unhide_thread_by_user_id/") else { return }
        
        let json: [String: Any] = ["unhide_thread_id": threadId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                let itemToRemoveIndex = self.hiddenThreadIdArr.firstIndex(of: threadId)
                self.hiddenThreadIdArr.remove(at: itemToRemoveIndex!)
                self.hiddenThreadsById.removeValue(forKey: threadId)
                self.isThreadHiddenByThreadId[threadId] = false
            }
        }.resume()
    }
    
    func hideComment(access: String, commentId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/users_profile/hide_comment_by_user_id/") else { return }
        
        let json: [String: Any] = ["hide_comment_id": commentId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                self.hiddenCommentIdArr.append(commentId)
                self.hiddenCommentsById[commentId] = self.comments[commentId]
                self.isCommentHiddenByCommentId[commentId] = true
            }
        }.resume()
    }
    
    func unhideComment(access: String, commentId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/users_profile/unhide_comment_by_user_id/") else { return }
        
        let json: [String: Any] = ["unhide_comment_id": commentId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                let itemToRemoveIndex = self.hiddenCommentIdArr.firstIndex(of: commentId)
                self.hiddenCommentIdArr.remove(at: itemToRemoveIndex!)
                self.hiddenCommentsById.removeValue(forKey: commentId)
                self.isCommentHiddenByCommentId[commentId] = false
            }
        }.resume()
    }
    
    func blockUser(access: String, userId: Int, targetBlockUserId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/users_profile/add_user_to_blacklist_by_user_id/") else { return }
        
        let json: [String: Any] = ["blacklist_user_id": targetBlockUserId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                self.blacklistedUserIdArr.append(targetBlockUserId)
                self.blacklistedUsersById[targetBlockUserId] = self.users[targetBlockUserId]
            }
        }.resume()
    }
    
    func unblockUser(access: String, userId: Int, targetUnblockUserId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/users_profile/remove_user_from_blacklist_by_user_id/") else { return }
        
        let json: [String: Any] = ["unblacklist_user_id": targetUnblockUserId]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                let indexToBeRemoved = self.blacklistedUserIdArr.firstIndex(of: targetUnblockUserId)
                
                self.blacklistedUserIdArr.remove(at: indexToBeRemoved!)
                self.blacklistedUsersById.removeValue(forKey: targetUnblockUserId)
            }
        }.resume()
    }
    
    func fetchBlacklistedUsers(access: String, userId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/users_profile/get_blacklisted_users_by_user_id/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let blacklistedUsersResponse: BlacklistedUsersResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        for blacklistedUser in blacklistedUsersResponse.blacklistedUsers {
                            if self.isUserBlockedByUserId[blacklistedUser.id] != nil && self.isUserBlockedByUserId[blacklistedUser.id]! == true {
                                continue
                            }
                            
                            self.users[blacklistedUser.id] = blacklistedUser
                            self.isUserBlockedByUserId[blacklistedUser.id] = true
                            self.blacklistedUsersById[blacklistedUser.id] = blacklistedUser
                            self.blacklistedUserIdArr.append(blacklistedUser.id)
                        }
                    }
                }
            }
        }.resume()
    }
    
    func fetchHiddenThreads(access: String, userId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/users_profile/get_hidden_threads_by_user_id/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let hiddenThreadsResponse: HiddenThreadsResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        for hiddenThread in hiddenThreadsResponse.hiddenThreads {
                            if self.isThreadHiddenByThreadId[hiddenThread.id] != nil && self.isThreadHiddenByThreadId[hiddenThread.id]! == true {
                                continue
                            }
                            
                            self.hiddenThreadIdArr.append(hiddenThread.id)
                            self.hiddenThreadsById[hiddenThread.id] = hiddenThread
                            self.isThreadHiddenByThreadId[hiddenThread.id] = true
                        }
                    }
                }
            }
        }.resume()
    }
    
    func fetchHiddenComments(access: String, userId: Int) {
        guard let url = URL(string: "http://127.0.0.1:8000/users_profile/get_hidden_comments_by_user_id/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let hiddenCommentsResponse: HiddenCommentsResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        for hiddenComment in hiddenCommentsResponse.hiddenComments {
                            if self.isCommentHiddenByCommentId[hiddenComment.id] != nil && self.isCommentHiddenByCommentId[hiddenComment.id]! == true {
                                continue
                            }
                            
                            self.hiddenCommentIdArr.append(hiddenComment.id)
                            self.hiddenCommentsById[hiddenComment.id] = hiddenComment
                            self.isCommentHiddenByCommentId[hiddenComment.id] = true
                        }
                    }
                }
            }
        }.resume()
    }
    
    func submitThread(access: String, forumId: Int, title: String, flair: Int, content: NSTextStorage, imageData: [UUID: Data], imagesArray: [UUID], userId: Int) {
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
                            
                            self.relativeDateStringByThreadId[tempThread.id] = RelativeDateTimeFormatter().localizedString(for: tempThread.created, relativeTo: Date())
                            
                            // emoji stuff
                            self.emojiArrByThreadId[tempThread.id] = [[]]
                            for emojiId in tempThread.emojis!.emojisIdArr {
                                if emojiId == 0 || emojiId == 1 {
                                    continue
                                }
                                self.emojiArrByThreadId[tempThread.id] = self.getShiftedArrayForAddEmoji(emojiId: emojiId, threadId: tempThread.id, commentId: nil)
                            }
                            
                            self.emojiCountByThreadId[tempThread.id] = tempThread.emojis?.emojiReactionCountDict
                            self.otherUsersArrReactToEmojiByThreadId[tempThread.id] = [:]
                            self.didReactToEmojiByThreadId[tempThread.id] = [:]
                            self.otherUsersSetReactToEmojiByThreadId[tempThread.id] = [:]
                            
                            self.emojiArrByThreadId[tempThread.id] = []
                            self.emojiArrByThreadId[tempThread.id]!.append([])
                            for emojiId in tempThread.emojis!.emojisIdArr {
                                self.otherUsersArrReactToEmojiByThreadId[tempThread.id]![emojiId] = tempThread.emojis!.userIdsArrPerEmojiDict[emojiId]
                                self.otherUsersSetReactToEmojiByThreadId[tempThread.id]![emojiId] = []
                                self.didReactToEmojiByThreadId[tempThread.id]![emojiId] = true
                                
                                self.emojiArrByThreadId[tempThread.id]![0].append(emojiId)
                            }
                            self.emojiArrByThreadId[tempThread.id]![0].append(999)
                            
                            self.isAddEmojiModalActiveByThreadViewId[tempThread.id] = false
                            self.isReplyBarReplyingToThreadByThreadId[tempThread.id] = true
                            self.replyTargetCommentIdByThreadId[tempThread.id] = -1
                            self.games[forumId]!.threadCount += 1
                            
                            self.isThreadHiddenByThreadId[tempThread.id] = false
                            
                            self.threadListByGameId[forumId]!.insert(tempThread.id, at: 0)
                            
                            if self.threadsImages[tempThread.id] == nil {
                                self.threadsImages[tempThread.id] = []
                            }
                            
                            if self.threadImagesHeight[tempThread.id] == nil {
                                self.threadImagesHeight[tempThread.id] = 0
                            }
                            
                            for id in imagesArray {
                                if imageData[id] != nil {
                                    let uiImage = UIImage(data: imageData[id]!)!
                                    self.threadsImages[tempThread.id]!.append(uiImage)
                                    self.threadImagesHeight[tempThread.id] = max(self.threadImagesHeight[tempThread.id]!, uiImage.size.height)
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
    
    func insertGameHistory(access: String, gameId: Int) {
        if self.myGameVisitHistory.count > 0 && self.myGameVisitHistory[0] == gameId {
            return
        }
        
        guard let url = URL(string: "http://127.0.0.1:8000/games/insert_game_history_by_user_id/?game_id=" + String(gameId)) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                var newGameHistoryArr : [Int] = [gameId]
                let maxGameHistoryLimit = 10
                
                DispatchQueue.main.async {
                    if self.myGameVisitHistorySet.contains(gameId) == true {
                        for visitedGameId in self.myGameVisitHistory {
                            if visitedGameId == gameId {
                                continue
                            }
                            
                            newGameHistoryArr.append(visitedGameId)
                        }
                        
                    } else {
                        if self.myGameVisitHistory.count == maxGameHistoryLimit {
                            let lastGameId = self.myGameVisitHistory.popLast()
                            self.myGameVisitHistorySet.remove(lastGameId!)
                        }
                        
                        self.myGameVisitHistorySet.insert(gameId)
                        newGameHistoryArr += self.myGameVisitHistory
                    }
                    
                    self.myGameVisitHistory = newGameHistoryArr
                }
            }
        }.resume()
    }
    
    func getGameHistory(access: String) {
        guard let url = URL(string: "http://127.0.0.1:8000/games/get_game_history_by_user_id/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let sessionConfig = URLSessionConfiguration.default
        let authString: String? = "Bearer \(access)"
        sessionConfig.httpAdditionalHeaders = ["Authorization": authString!]
        let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
        
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let gameHistoryResponse: GameHistoryResponse = load(jsonData: jsonString.data(using: .utf8)!)
                    
                    DispatchQueue.main.async {
                        var gameHistorySet = Set<Int>()
                        for gameId in gameHistoryResponse.gameHistory {
                            gameHistorySet.insert(gameId)
                        }
                        
                        self.myGameVisitHistorySet = gameHistorySet
                        self.myGameVisitHistory = gameHistoryResponse.gameHistory
                    }
                }
            }
        }.resume()
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
                        self.commentsTextStorage[tempMainComment.id] = self.generateTextStorageFromJson(isThread: false, id: tempMainComment.id)
                        self.commentsDesiredHeight[tempMainComment.id] = 0
                        self.threadsNextPageStartIndex[tempMainComment.parentThread!]! += 1
                        self.commentNextPageStartIndex[tempMainComment.id] = 0
                        self.childCommentListByParentCommentId[tempMainComment.id] = []
                        self.incrementTreeNodes(node: tempMainComment)
                        self.votes[tempVote.id] = tempVote
                        self.voteCommentMapping[tempMainComment.id] = tempVote.id
                        self.relativeDateStringByCommentId[tempMainComment.id] = RelativeDateTimeFormatter().localizedString(for: tempMainComment.created, relativeTo: Date())
                        
                        self.visibleChildCommentsNum[tempMainComment.id] = 0
                        self.voteCountStringByCommentId[tempMainComment.id] = self.transformVotesString(points: 1)
                        self.isCommentHiddenByCommentId[tempMainComment.id] = false
                        
                        //                        // emoji stuff
                        //                        self.emojiArrByCommentId[tempMainComment.id] = [[]]
                        //
                        //                        for emojiId in tempMainComment.emojis!.emojisIdArr {
                        //                            if emojiId == 0 || emojiId == 1 {
                        //                                continue
                        //                            }
                        //                            self.emojiArrByCommentId[tempMainComment.id] = self.getShiftedArrayForAddEmoji(emojiId: emojiId, threadId: nil, commentId: tempMainComment.id)
                        //                        }
                        //
                        //                        self.emojiCountByCommentId[tempMainComment.id] = tempMainComment.emojis?.emojiReactionCountDict
                        //                        self.otherUsersArrReactToEmojiByCommentId[tempMainComment.id] = [:]
                        //                        self.didReactToEmojiByCommentId[tempMainComment.id] = [:]
                        //                        self.otherUsersSetReactToEmojiByCommentId[tempMainComment.id] = [:]
                        //
                        //                        self.emojiArrByCommentId[tempMainComment.id] = []
                        //                        self.emojiArrByCommentId[tempMainComment.id]!.append([])
                        //                        for emojiId in tempMainComment.emojis!.emojisIdArr {
                        //                            self.otherUsersArrReactToEmojiByCommentId[tempMainComment.id]![emojiId] = tempMainComment.emojis!.userIdsArrPerEmojiDict[emojiId]
                        //                            self.otherUsersSetReactToEmojiByCommentId[tempMainComment.id]![emojiId] = []
                        //                            self.didReactToEmojiByCommentId[tempMainComment.id]![emojiId] = true
                        //
                        //                            self.emojiArrByCommentId[tempMainComment.id]![0].append(emojiId)
                        //                        }
                        //                        self.emojiArrByCommentId[tempMainComment.id]![0].append(999)
                        
                        //                        self.isAddEmojiModalActiveByThreadViewId[tempMainComment.id] = false
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
                        self.commentsTextStorage[tempChildComment.id] = self.generateTextStorageFromJson(isThread: false, id: tempChildComment.id)
                        self.commentsDesiredHeight[tempChildComment.id] = 0
                        self.childCommentListByParentCommentId[tempChildComment.id] = [Int]()
                        
                        if self.commentNextPageStartIndex[tempChildComment.parentPost!]! != -1 {
                            self.commentNextPageStartIndex[tempChildComment.parentPost!]! += 1
                        }
                        
                        self.incrementTreeNodes(node: tempChildComment)
                        self.votes[tempVote.id] = tempVote
                        self.voteCommentMapping[tempChildComment.id] = tempVote.id
                        
                        self.visibleChildCommentsNum[tempChildComment.parentPost!]! += 1
                        self.visibleChildCommentsNum[tempChildComment.id] = 0
                        self.relativeDateStringByCommentId[tempChildComment.id] = RelativeDateTimeFormatter().localizedString(for: tempChildComment.created, relativeTo: Date())
                        self.voteCountStringByCommentId[tempChildComment.id] = self.transformVotesString(points: 1)
                        
                        self.commentNextPageStartIndex[tempChildComment.id] = -1
                        self.isCommentHiddenByCommentId[tempChildComment.id] = false
                        
                        //                        // emoji stuff
                        //                        self.emojiArrByCommentId[tempChildComment.id] = [[]]
                        //
                        //                        for emojiId in tempChildComment.emojis!.emojisIdArr {
                        //                            if emojiId == 0 || emojiId == 1 {
                        //                                continue
                        //                            }
                        //                            self.emojiArrByCommentId[tempChildComment.id] = self.getShiftedArrayForAddEmoji(emojiId: emojiId, threadId: nil, commentId: tempChildComment.id)
                        //                        }
                        //
                        //                        self.emojiCountByCommentId[tempChildComment.id] = tempChildComment.emojis?.emojiReactionCountDict
                        //                        self.otherUsersArrReactToEmojiByCommentId[tempChildComment.id] = [:]
                        //                        self.didReactToEmojiByCommentId[tempChildComment.id] = [:]
                        //                        self.otherUsersSetReactToEmojiByCommentId[tempChildComment.id] = [:]
                        //
                        //                        self.emojiArrByCommentId[tempChildComment.id] = []
                        //                        self.emojiArrByCommentId[tempChildComment.id]!.append([])
                        //                        for emojiId in tempChildComment.emojis!.emojisIdArr {
                        //                            self.otherUsersArrReactToEmojiByCommentId[tempChildComment.id]![emojiId] = tempChildComment.emojis!.userIdsArrPerEmojiDict[emojiId]
                        //                            self.otherUsersSetReactToEmojiByCommentId[tempChildComment.id]![emojiId] = []
                        //                            self.didReactToEmojiByCommentId[tempChildComment.id]![emojiId] = true
                        //
                        //                            self.emojiArrByCommentId[tempChildComment.id]![0].append(emojiId)
                        //                        }
                        //                        self.emojiArrByCommentId[tempChildComment.id]![0].append(999)
                        //
                        ////                    self.isAddEmojiModalActiveByThreadViewId[tempMainComment.id] = false
                        
                        self.childCommentListByParentCommentId[tempChildComment.parentPost!]!.insert(tempChildComment.id, at: 0)
                    }
                }
            }
        }.resume()
    }
    
    func fetchCommentTreeByThreadId(access: String, threadId: Int, start:Int = 0, count:Int = 10, size:Int = 50, refresh: Bool = false, userId: Int) {
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
                            self.isThreadViewLoadedByThreadId[threadId] = true
                            return
                        }
                        
                        if self.moreCommentsByThreadId[threadId] == nil {
                            self.moreCommentsByThreadId[threadId] = [Int]()
                        }
                        
                        var commentListToBeAppendedToThread : [Int] = []
                        var commentListToBeAppendedToComment : [Int: [Int]] = [:]
                        
                        for comment in commentLoadTree.addedComments {
                            self.comments[comment.id] = comment
                            self.isCommentHiddenByCommentId[comment.id] = false

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
                            
                            self.relativeDateStringByCommentId[comment.id] = RelativeDateTimeFormatter().localizedString(for: comment.created, relativeTo: Date())
                            
                            self.voteCountStringByCommentId[comment.id] = self.transformVotesString(points: comment.upvotes - comment.downvotes)
                            
                            //                            self.emojiCountByCommentId[comment.id] = comment.emojis!.emojiReactionCountDict
                            //
                            //                            self.otherUsersArrReactToEmojiByCommentId[comment.id] = [:]
                            //                            self.otherUsersSetReactToEmojiByCommentId[comment.id] = [:]
                            //                            self.didReactToEmojiByCommentId[comment.id] = [:]
                            //
                            //                            for emojiId in comment.emojis!.emojisIdArr {
                            //                                self.otherUsersArrReactToEmojiByCommentId[comment.id]![emojiId] = []
                            //                                self.otherUsersSetReactToEmojiByCommentId[comment.id]![emojiId] = []
                            //
                            //                                self.didReactToEmojiByCommentId[comment.id]![emojiId] = false
                            //
                            //                                for reactedUserId in comment.emojis!.userIdsArrPerEmojiDict[emojiId]! {
                            //                                    if userId == reactedUserId {
                            //                                        self.didReactToEmojiByCommentId[comment.id]![emojiId] = true
                            //                                    } else {
                            //                                        self.otherUsersSetReactToEmojiByCommentId[comment.id]![emojiId]!.insert(reactedUserId)
                            //                                        self.otherUsersArrReactToEmojiByCommentId[comment.id]![emojiId]!.append(reactedUserId)
                            //                                    }
                            //                                }
                            //                            }
                            //
                            //                            self.emojiArrByCommentId[comment.id] = []
                            //                            var emojiArrToBeAdded = [Int]()
                            //
                            //                            for emojiId in comment.emojis!.emojisIdArr {
                            //                                if emojiId == 0 {
                            //                                    emojiArrToBeAdded.insert(emojiId, at: 0)
                            //                                } else if emojiId == 1 {
                            //                                    if emojiArrToBeAdded.count != 0 && emojiArrToBeAdded[0] == 0 {
                            //                                        emojiArrToBeAdded.insert(1, at: 1)
                            //                                    } else {
                            //                                        emojiArrToBeAdded.insert(1, at: 0)
                            //                                    }
                            //                                } else {
                            //                                    emojiArrToBeAdded.append(emojiId)
                            //                                }
                            //                            }
                            //                            self.emojiArrByCommentId[comment.id] = self.getInitialEmojiArray(emojiArr: emojiArrToBeAdded, threadId: nil, commentId: comment.id)
                            
                            self.moreCommentsByParentCommentId[comment.id] = [Int]()
                        }
                        
                        for (parentComment, childComments) in commentListToBeAppendedToComment {
                            self.childCommentListByParentCommentId[parentComment]! = childComments
                        }
                        
                        for vote in commentLoadTree.addedVotes {
                            self.votes[vote.id] = vote
                            self.voteCommentMapping[vote.comment!] = vote.id
                        }
                        
                        for user in commentLoadTree.usersResponse {
                            self.users[user.id] = user
                        }
                        
                        self.mainCommentListByThreadId[threadId]! += commentListToBeAppendedToThread
                        self.isThreadViewLoadedByThreadId[threadId] = true
                        
                        self.moreCommentsByThreadId[threadId]! = [Int]()
                        for comment in commentLoadTree.moreComments {
                            if comment.parentThread != nil {
                                self.moreCommentsByThreadId[threadId]!.append(comment.id)
                            } else {
                                self.moreCommentsByParentCommentId[comment.parentPost!]!.append(comment.id)
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    
    func fetchCommentTreeByParentComment(access: String, parentCommentId: Int, start:Int = 0, count:Int = 10, size:Int = 50, userId: Int) {
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
                            self.isCommentHiddenByCommentId[comment.id] = false
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
                            
                            self.relativeDateStringByCommentId[comment.id] = RelativeDateTimeFormatter().localizedString(for: comment.created, relativeTo: Date())
                            
                            self.voteCountStringByCommentId[comment.id] = self.transformVotesString(points: comment.upvotes - comment.downvotes)
                            //                            self.emojiCountByCommentId[comment.id] = comment.emojis!.emojiReactionCountDict
                            //
                            //                            self.otherUsersArrReactToEmojiByCommentId[comment.id] = [:]
                            //                            self.otherUsersSetReactToEmojiByCommentId[comment.id] = [:]
                            //                            self.didReactToEmojiByCommentId[comment.id] = [:]
                            //
                            //                            for emojiId in comment.emojis!.emojisIdArr {
                            //                                self.otherUsersArrReactToEmojiByCommentId[comment.id]![emojiId] = []
                            //                                self.otherUsersSetReactToEmojiByCommentId[comment.id]![emojiId] = []
                            //
                            //                                self.didReactToEmojiByCommentId[comment.id]![emojiId] = false
                            //
                            //                                for reactedUserId in comment.emojis!.userIdsArrPerEmojiDict[emojiId]! {
                            //                                    if userId == reactedUserId {
                            //                                        self.didReactToEmojiByCommentId[comment.id]![emojiId] = true
                            //                                    } else {
                            //                                        self.otherUsersSetReactToEmojiByCommentId[comment.id]![emojiId]!.insert(reactedUserId)
                            //                                        self.otherUsersArrReactToEmojiByCommentId[comment.id]![emojiId]!.append(reactedUserId)
                            //                                    }
                            //                                }
                            //                            }
                            //
                            //                            self.emojiArrByCommentId[comment.id] = []
                            //                            var emojiArrToBeAdded = [Int]()
                            //
                            //                            for emojiId in comment.emojis!.emojisIdArr {
                            //                                if emojiId == 0 {
                            //                                    emojiArrToBeAdded.insert(emojiId, at: 0)
                            //                                } else if emojiId == 1 {
                            //                                    if emojiArrToBeAdded.count != 0 && emojiArrToBeAdded[0] == 0 {
                            //                                        emojiArrToBeAdded.insert(1, at: 1)
                            //                                    } else {
                            //                                        emojiArrToBeAdded.insert(1, at: 0)
                            //                                    }
                            //                                } else {
                            //                                    emojiArrToBeAdded.append(emojiId)
                            //                                }
                            //                            }
                            //                            self.emojiArrByCommentId[comment.id] = self.getInitialEmojiArray(emojiArr: emojiArrToBeAdded, threadId: nil, commentId: comment.id)
                            
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
    
    func transformVotesString(points: Int) -> String {
        let isNegative = false
        let numPoints = points
        
        var concatVotesStr = ""
        if numPoints > 1000000 {
            concatVotesStr = String((Double(numPoints) / 1000000 * 10).rounded() / 10)
            concatVotesStr += " M"
        } else if numPoints > 1000 {
            concatVotesStr = String((Double(numPoints) / 1000 * 10).rounded() / 10)
            concatVotesStr += " K"
        } else {
            concatVotesStr += String(numPoints)
        }
        
        return ((isNegative ? "-" : "" ) + concatVotesStr)
    }
    
    func fetchThreads(access: String, game: Game, start:Int = 0, count:Int = 10, refresh: Bool = false, userId: Int) {
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
                            self.isForumViewLoadedByGameId[game.id] = true
                            return
                        }
                        
                        var newThreadsList: [Int] = []
                        for thread in tempThreadsResponse.threadsResponse {
                            newThreadsList.append(thread.id)
                            self.threads[thread.id] = thread
                            self.mainCommentListByThreadId[thread.id] = [Int]()
                            self.isThreadHiddenByThreadId[thread.id] = false
                            
                            self.threadsIndexInGameList[thread.id] = self.threadListByGameId[game.id]!.count - 1
                            self.threadsNextPageStartIndex[thread.id] = 0
                            self.threadsTextStorage[thread.id] = self.generateTextStorageFromJson(isThread: true, id: thread.id)
                            
                            if self.threadsDesiredHeight[thread.id] == nil {
                                self.threadsDesiredHeight[thread.id] = 0
                            }
                            
                            if self.threadViewReplyBarDesiredHeight[thread.id] == nil {
                                self.threadViewReplyBarDesiredHeight[thread.id] = 0
                            }
                            
                            self.isReplyBarReplyingToThreadByThreadId[thread.id] = true
                            self.replyTargetCommentIdByThreadId[thread.id] = -1
                            self.relativeDateStringByThreadId[thread.id] = RelativeDateTimeFormatter().localizedString(for: thread.created, relativeTo: Date())
                            
                            self.emojiCountByThreadId[thread.id] = thread.emojis?.emojiReactionCountDict
                            
                            self.otherUsersArrReactToEmojiByThreadId[thread.id] = [:]
                            self.otherUsersSetReactToEmojiByThreadId[thread.id] = [:]
                            self.didReactToEmojiByThreadId[thread.id] = [:]
                            
                            for emojiId in thread.emojis!.emojisIdArr {
                                self.otherUsersArrReactToEmojiByThreadId[thread.id]![emojiId] = []
                                self.otherUsersSetReactToEmojiByThreadId[thread.id]![emojiId] = []
                                
                                self.didReactToEmojiByThreadId[thread.id]![emojiId] = false
                                
                                for reactedUserId in thread.emojis!.userIdsArrPerEmojiDict[emojiId]! {
                                    if userId == reactedUserId {
                                        self.didReactToEmojiByThreadId[thread.id]![emojiId] = true
                                    } else {
                                        self.otherUsersSetReactToEmojiByThreadId[thread.id]![emojiId]!.insert(reactedUserId)
                                        self.otherUsersArrReactToEmojiByThreadId[thread.id]![emojiId]!.append(reactedUserId)
                                    }
                                }
                            }
                            
                            self.emojiArrByThreadId[thread.id] = []
                            var emojiArrToBeAdded = [Int]()
                            
                            for emojiId in thread.emojis!.emojisIdArr {
                                if emojiId == 0 {
                                    emojiArrToBeAdded.insert(emojiId, at: 0)
                                } else if emojiId == 1 {
                                    if emojiArrToBeAdded.count != 0 && emojiArrToBeAdded[0] == 0 {
                                        emojiArrToBeAdded.insert(1, at: 1)
                                    } else {
                                        emojiArrToBeAdded.insert(1, at: 0)
                                    }
                                } else {
                                    emojiArrToBeAdded.append(emojiId)
                                }
                            }
                            self.emojiArrByThreadId[thread.id] = self.getInitialEmojiArray(emojiArr: emojiArrToBeAdded, threadId: thread.id, commentId: nil)
                            
                            self.isAddEmojiModalActiveByThreadViewId[thread.id] = false
                        }
                        
                        self.threadListByGameId[game.id]! += newThreadsList
                        self.isForumViewLoadedByGameId[game.id] = true

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
                    let uiImage = UIImage(data: data)!
                    self.threadsImages[thread.id]!.append(uiImage)
                    
                    if self.threadImagesHeight[thread.id] == nil {
                        self.threadImagesHeight[thread.id] = 0
                    }
                    
                    self.threadImagesHeight[thread.id] = max(self.threadImagesHeight[thread.id]!, uiImage.size.height)
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
                            
                            if self.games[game.id] == nil {
                                self.games[game.id] = game
                            }
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
                            
                            if self.games[game.id] == nil {
                                self.games[game.id] = game
                            }
                            
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
                            
                            if self.gamesByYear[releaseYear]![releaseMonth]![releaseDay]!.contains(game.id) {
                                continue
                            } else {
                                self.gamesByYear[releaseYear]![releaseMonth]![releaseDay]!.insert(game.id)
                            }
                        }
                        
                        for (year, _) in self.gamesByYear {
                            
                            if self.hasGameByYear[year] == nil || self.hasGameByYear[year]! == false {
                                self.hasGameByYear[year] = true
                            }
                            
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
                    self.games[game.id]!.followerCount += 1
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
                    self.games[game.id]!.followerCount -= 1
                }
            }
        }.resume()
    }
    
    func upvoteByExistingVoteIdThread(access: String, voteId: Int, thread: Thread, userId: Int) {
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
                    self.addEmojiToStore(emojiId: 0, threadId: thread.id, commentId: nil, userId: userId, newEmojiCount: self.threads[thread.id]!.upvotes)
                }
            }
        }.resume()
    }
    
    func downvoteByExistingVoteIdThread(access: String, voteId: Int, thread: Thread, userId: Int) {
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
                    self.addEmojiToStore(emojiId: 1, threadId: thread.id, commentId: nil, userId: userId, newEmojiCount: self.threads[thread.id]!.downvotes)
                }
            }
        }.resume()
    }
    
    func upvoteByExistingVoteIdComment(access: String, voteId: Int, comment: Comment, userId: Int) {
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
                    
                    self.voteCountStringByCommentId[comment.id] = self.transformVotesString(points: self.comments[comment.id]!.upvotes - self.comments[comment.id]!.downvotes)
                    //                    self.addEmojiToStore(emojiId: 0, threadId: nil, commentId: comment.id, userId: userId, newEmojiCount: self.comments[comment.id]!.upvotes)
                }
            }
        }.resume()
    }
    
    func downvoteByExistingVoteIdComment(access: String, voteId: Int, comment: Comment, userId: Int) {
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
                    
                    self.voteCountStringByCommentId[comment.id] = self.transformVotesString(points: self.comments[comment.id]!.upvotes - self.comments[comment.id]!.downvotes)
                    //                    self.addEmojiToStore(emojiId: 0, threadId: nil, commentId: comment.id, userId: userId, newEmojiCount: self.comments[comment.id]!.upvotes)
                }
            }
        }.resume()
    }
    
    func addNewUpvoteThread(access: String, thread: Thread, userId: Int) {
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
                        
                        self.addEmojiToStore(emojiId: 0, threadId: thread.id, commentId: nil, userId: userId, newEmojiCount: self.threads[thread.id]!.upvotes)
                    }
                }
            }
        }.resume()
    }
    
    func switchUpvoteThread(access: String, thread: Thread, userId: Int) {
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
                    
                    self.removeEmojiFromStore(emojiId: 1, threadId: thread.id, commentId: nil, userId: userId, newEmojiCount: self.threads[thread.id]!.downvotes)
                    self.addEmojiToStore(emojiId: 0, threadId: thread.id, commentId: nil, userId: userId, newEmojiCount: self.threads[thread.id]!.upvotes)
                }
            }
        }.resume()
    }
    
    func addNewDownvoteThread(access: String, thread: Thread, userId: Int) {
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
                        
                        self.addEmojiToStore(emojiId: 1, threadId: thread.id, commentId: nil, userId: userId, newEmojiCount: self.threads[thread.id]!.downvotes)
                    }
                }
            }
        }.resume()
    }
    
    func switchDownvoteThread(access: String, thread: Thread, userId: Int) {
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
                    
                    self.removeEmojiFromStore(emojiId: 0, threadId: thread.id, commentId: nil, userId: userId, newEmojiCount: self.threads[thread.id]!.upvotes)
                    
                    self.addEmojiToStore(emojiId: 1, threadId: thread.id, commentId: nil, userId: userId, newEmojiCount: self.threads[thread.id]!.downvotes)
                }
            }
            
        }.resume()
    }
    
    func addNewUpvoteComment(access: String, comment: Comment, userId: Int) {
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
                        
                        self.voteCountStringByCommentId[comment.id] = self.transformVotesString(points: self.comments[comment.id]!.upvotes - self.comments[comment.id]!.downvotes)
                        
                        //                        self.addEmojiToStore(emojiId: 0, threadId: nil, commentId: comment.id, userId: userId, newEmojiCount: self.comments[comment.id]!.upvotes)
                    }
                }
            }
        }.resume()
    }
    
    func switchUpvoteComment(access: String, comment: Comment, userId: Int) {
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
                    self.voteCountStringByCommentId[comment.id] = self.transformVotesString(points: self.comments[comment.id]!.upvotes - self.comments[comment.id]!.downvotes)
                    //                    self.removeEmojiFromStore(emojiId: 1, threadId: nil, commentId: comment.id, userId: userId, newEmojiCount: self.comments[comment.id]!.downvotes)
                    //                    self.addEmojiToStore(emojiId: 0, threadId: nil, commentId: comment.id, userId: userId, newEmojiCount: self.comments[comment.id]!.upvotes)
                }
            }
        }.resume()
    }
    
    func addNewDownvoteComment(access: String, comment: Comment, userId: Int) {
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
                        self.voteCountStringByCommentId[comment.id] = self.transformVotesString(points: self.comments[comment.id]!.upvotes - self.comments[comment.id]!.downvotes)
                        //                        self.addEmojiToStore(emojiId: 1, threadId: nil, commentId: comment.id, userId: userId, newEmojiCount: self.comments[comment.id]!.downvotes)
                    }
                }
            }
        }.resume()
    }
    
    func switchDownvoteComment(access: String, comment: Comment, userId: Int) {
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
                    
                    self.voteCountStringByCommentId[comment.id] = self.transformVotesString(points: self.comments[comment.id]!.upvotes - self.comments[comment.id]!.downvotes)
                    //  self.removeEmojiFromStore(emojiId: 1, threadId: nil, commentId: comment.id, userId: userId, newEmojiCount: self.comments[comment.id]!.downvotes)
                    //  self.addEmojiToStore(emojiId: 1, threadId: nil, commentId: comment.id, userId: userId, newEmojiCount: self.comments[comment.id]!.upvotes)
                }
            }
        }.resume()
    }
    
    func deleteCommentVote(access: String, vote: Vote, userId: Int) {
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
                    let commentId = vote.comment!
                    if vote.direction == 1 {
                        self.comments[commentId]!.upvotes -= 1
                    } else {
                        self.comments[commentId]!.downvotes -= 1
                    }
                    
                    let originalVoteDirection = self.votes[vote.id]!.direction
                    self.votes[vote.id]!.direction = 0
                    
                    self.voteCountStringByCommentId[vote.comment!] = self.transformVotesString(points: self.comments[vote.comment!]!.upvotes - self.comments[vote.comment!]!.downvotes)
                    //                    self.removeEmojiFromStore(emojiId: originalVoteDirection == 1 ? 0 : 1, threadId: nil, commentId: vote.comment!, userId: userId, newEmojiCount: vote.direction == 1 ? self.comments[vote.comment!]!.upvotes : self.comments[vote.comment!]!.downvotes)
                }
            }
        }.resume()
    }
    
    func deleteThreadVote(access: String, vote: Vote, userId: Int) {
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
                    
                    let threadId = vote.thread!
                    
                    if vote.direction == 1 {
                        self.threads[threadId]!.upvotes -= 1
                    } else {
                        self.threads[threadId]!.downvotes -= 1
                    }
                    
                    let originalVoteDirection = self.votes[vote.id]!.direction
                    self.votes[vote.id]!.direction = 0
                    
                    self.removeEmojiFromStore(emojiId: originalVoteDirection == 1 ? 0 : 1, threadId: vote.thread!, commentId: nil, userId: userId, newEmojiCount: vote.direction == 1 ? self.threads[vote.thread!]!.upvotes : self.threads[vote.thread!]!.downvotes)
                }
            }
        }.resume()
    }
}

