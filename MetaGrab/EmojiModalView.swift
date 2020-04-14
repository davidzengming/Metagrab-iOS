//
//  EmojiModalView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-03-30.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct EmojiModalView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    var forumId: Int
    var isThreadView: Bool
    
    func dismissView() {
        if isThreadView == false {
            self.gameDataStore.isAddEmojiModalActiveByForumId[self.forumId] = false
        } else {
            self.gameDataStore.isAddEmojiModalActiveByThreadViewId[self.getClickedThreadId()] = false
        }
    }
    
    func getClickedThreadId() -> Int {
        return self.gameDataStore.addEmojiThreadIdByForumId[self.forumId]!
    }
    
    func addEmoji(emojiId: Int) {
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
        
        if self.gameDataStore.didReactToEmojiByThreadId[self.gameDataStore.addEmojiThreadIdByForumId[self.forumId]!]![emojiId] != nil && self.gameDataStore.didReactToEmojiByThreadId[self.gameDataStore.addEmojiThreadIdByForumId[self.forumId]!]![emojiId]! == true {
            return
        }
        
        // too many emojis, leave room for upvote/downvote emojis
        let rowCount = self.gameDataStore.emojiArrByThreadId[threadId]!.count
        let colCount = self.gameDataStore.emojiArrByThreadId[threadId]![rowCount - 1].count
        
        if rowCount == 2 && colCount >= 3 && self.gameDataStore.emojiCountByThreadId[threadId]![emojiId] == nil {
            let hasUpvote = self.gameDataStore.emojiArrByThreadId[threadId]![0][0] == 0
            let hasDownvote = self.gameDataStore.emojiArrByThreadId[threadId]![0][0] == 1 || self.gameDataStore.emojiArrByThreadId[threadId]![0][1] == 1

            if !hasUpvote && !hasDownvote && (emojiId != 0 && emojiId != 1) {
                print("Too many emojis")
                return
            } else if ((hasUpvote && emojiId != 1) || (hasDownvote && emojiId != 0)) && colCount == self.gameDataStore.maxEmojiCountPerRow {
                print("Too many emojis")
                return
            }
        }
        
        self.gameDataStore.addEmojiByThreadId(access: self.userDataStore.token!.access, threadId: self.getClickedThreadId(), emojiId: emojiId, userId: self.userDataStore.token!.userId)
    }
    
    var body: some View {
        VStack {
            Button("Dismiss") {
                self.dismissView()
            }
            
            Text("Emojis")
                .padding()
            
            VStack {
                ScrollView(.vertical) {
                    HStack(spacing: 0) {
                        ForEach(self.gameDataStore.emojiArray, id: \.self) { emojiId in
                            Image(uiImage: self.gameDataStore.emojis[emojiId]!)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .onTapGesture {
                                    self.addEmoji(emojiId: emojiId)
                                    self.dismissView()
                            }
                        }
                    }
                }
            }
            .frame(width: 100, height: 25)
        }
    }
}
