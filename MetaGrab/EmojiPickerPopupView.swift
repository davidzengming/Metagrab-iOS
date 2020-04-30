//
//  EmojiModalView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-03-30.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct EmojiPickerPopupView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    // id of the forum if view is used in a ForumView
    var parentForumId: Int?
    
    // id of the ancestor thread if view is used in a ThreadView
    var ancestorThreadId: Int?
    
    func dismissView() {
        if ancestorThreadId == nil {
            self.gameDataStore.isAddEmojiModalActiveByForumId[self.parentForumId!] = false
        } else {
            self.gameDataStore.isAddEmojiModalActiveByThreadViewId[self.ancestorThreadId!] = false
        }
    }
    
    // get the threadId clicked in a forumView or threadView
    func getClickedThreadId() -> Int {
        return self.gameDataStore.addEmojiThreadIdByForumId[self.parentForumId!]!
    }
    
    //    // get the commentId clicked in a threadView
    //    func getClickedCommentId() -> Int {
    //        return self.gameDataStore.addEmojiCommentIdByThreadId[self.ancestorThreadId!]!
    //    }
    
    func addEmoji(emojiId: Int) {
        //        if ancestorThreadId != nil && self.gameDataStore.addEmojiThreadIdByForumId[self.parentForumId!] != nil && self.gameDataStore.addEmojiViewLastClickedIsThread[self.ancestorThreadId!]! == true {
        let threadId = getClickedThreadId()
        // Upvote
        if emojiId == 0 {
            if self.gameDataStore.voteThreadMapping[threadId] != nil {
                if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 1 {
                    return
                } else if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 0 {
                    self.gameDataStore.upvoteByExistingVoteIdThread(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteThreadMapping[threadId]!, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
                } else {
                    self.gameDataStore.switchUpvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
                }
            } else {
                self.gameDataStore.addNewUpvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
            }
            return
        }
        
        // Downvote
        if emojiId == 1 {
            if self.gameDataStore.voteThreadMapping[threadId] != nil {
                if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == -1 {
                    return
                } else if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 0 {
                    self.gameDataStore.downvoteByExistingVoteIdThread(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteThreadMapping[threadId]!, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
                } else {
                    self.gameDataStore.switchDownvoteThread(access:  self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
                }
            } else {
                self.gameDataStore.addNewDownvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
            }
            
            return
        }
        
        // if already reacted on this emoji, return
        if self.gameDataStore.didReactToEmojiByThreadId[self.gameDataStore.addEmojiThreadIdByForumId[self.parentForumId!]!]![emojiId] != nil && self.gameDataStore.didReactToEmojiByThreadId[self.gameDataStore.addEmojiThreadIdByForumId[self.parentForumId!]!]![emojiId]! == true {
            return
        }
        
        // too many emojis, leave room for upvote/downvote emojis
        let rowCount = self.gameDataStore.emojiArrByThreadId[threadId]!.count
        let colCount = self.gameDataStore.emojiArrByThreadId[threadId]![rowCount - 1].count
        
        if rowCount == 2 && colCount >= 3 && self.gameDataStore.emojiCountByThreadId[threadId]![emojiId] == nil {
            let hasUpvote = self.gameDataStore.emojiArrByThreadId[threadId]![0][0] == 0
            let hasDownvote = self.gameDataStore.emojiArrByThreadId[threadId]![0][0] == 1 || self.gameDataStore.emojiArrByThreadId[threadId]![0][1] == 1
            
            if !hasUpvote && !hasDownvote && (emojiId != 0 && emojiId != 1) {
                print("Too many emojis, don't have both upvote or downvotes need 2 spots for them.")
                return
            } else if colCount == self.gameDataStore.maxEmojiCountPerRow && ((!hasUpvote && emojiId != 0) || (!hasDownvote  && emojiId != 1)) {
                print("Too many emojis, don't have upvote or downvote and needs 1 spot for it.")
                return
            }
        }
        
        self.gameDataStore.addEmojiByThreadId(access: self.userDataStore.token!.access, threadId: self.getClickedThreadId(), emojiId: emojiId, userId: self.userDataStore.token!.userId)
        //        }
        //        else {
        //            let commentId = getClickedCommentId()
        //            // Upvote
        //            if emojiId == 0 {
        //                if self.gameDataStore.voteThreadMapping[commentId] != nil {
        //                    if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[commentId]!]!.direction == 1 {
        //                        return
        //                    } else if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[commentId]!]!.direction == 0 {
        //                        self.gameDataStore.upvoteByExistingVoteIdThread(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteThreadMapping[commentId]!, thread: self.gameDataStore.threads[commentId]!, userId: self.userDataStore.token!.userId)
        //                    } else {
        //                        self.gameDataStore.switchUpvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[commentId]!, userId: self.userDataStore.token!.userId)
        //                    }
        //                } else {
        //                    self.gameDataStore.addNewUpvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[commentId]!, userId: self.userDataStore.token!.userId)
        //                }
        //                return
        //            }
        //
        //            // Downvote
        //            if emojiId == 1 {
        //                if self.gameDataStore.voteThreadMapping[commentId] != nil {
        //                    if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[commentId]!]!.direction == -1 {
        //                        return
        //                    } else if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[commentId]!]!.direction == 0 {
        //                        self.gameDataStore.downvoteByExistingVoteIdThread(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteThreadMapping[commentId]!, thread: self.gameDataStore.threads[commentId]!, userId: self.userDataStore.token!.userId)
        //                    } else {
        //                        self.gameDataStore.switchDownvoteThread(access:  self.userDataStore.token!.access, thread: self.gameDataStore.threads[commentId]!, userId: self.userDataStore.token!.userId)
        //                    }
        //                } else {
        //                    self.gameDataStore.addNewDownvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[commentId]!, userId: self.userDataStore.token!.userId)
        //                }
        //
        //                return
        //            }
        //
        //            // if already reacted on this emoji, return
        //            if self.gameDataStore.didReactToEmojiByCommentId[self.gameDataStore.addEmojiCommentIdByThreadId[self.ancestorThreadId!]!]![emojiId] != nil && self.gameDataStore.didReactToEmojiByCommentId[self.gameDataStore.addEmojiCommentIdByThreadId[self.ancestorThreadId!]!]![emojiId]! == true {
        //                return
        //            }
        //
        //            // too many emojis, leave room for upvote/downvote emojis
        //            let rowCount = self.gameDataStore.emojiArrByCommentId[commentId]!.count
        //            let colCount = self.gameDataStore.emojiArrByCommentId[commentId]![rowCount - 1].count
        //
        //            if rowCount == 2 && colCount >= 3 && self.gameDataStore.emojiCountByCommentId[commentId]![emojiId] == nil {
        //                let hasUpvote = self.gameDataStore.emojiArrByCommentId[commentId]![0][0] == 0
        //                let hasDownvote = self.gameDataStore.emojiArrByCommentId[commentId]![0][0] == 1 || self.gameDataStore.emojiArrByCommentId[commentId]![0][1] == 1
        //
        //                if !hasUpvote && !hasDownvote && (emojiId != 0 && emojiId != 1) {
        //                    print("Too many emojis")
        //                    return
        //                } else if ((hasUpvote && emojiId != 1) || (hasDownvote && emojiId != 0)) && colCount == self.gameDataStore.maxEmojiCountPerRow {
        //                    print("Too many emojis")
        //                    return
        //                }
        //            }
        //
        //            self.gameDataStore.addEmojiByCommentId(access: self.userDataStore.token!.access, commentId: self.getClickedCommentId(), emojiId: emojiId, userId: self.userDataStore.token!.userId)
        //        }
    }
    
    var body: some View {
        GeometryReader { a in
            VStack {
                Button(action: self.dismissView) {
                    Text("Dismiss")
                    .frame(width: a.size.width * 0.9)
                    .padding(5)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                }
                .padding()
                
                VStack(spacing: 0){
                    ScrollView(.vertical) {
                        HStack(spacing: 0) {
                            ForEach(self.gameDataStore.emojiArray, id: \.self) { emojiId in
                                Image(uiImage: self.gameDataStore.emojis[emojiId]!)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding(.horizontal, 3)
                                    .onTapGesture {
                                        self.addEmoji(emojiId: emojiId)
                                        self.dismissView()
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
    }
}
