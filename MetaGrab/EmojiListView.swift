//
//  EmojiListView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-04-13.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct EmojiListView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var threadId: Int
    var isInThreadView: Bool
    
    func addEmoji(emojiId: Int) {
        if self.gameDataStore.didReactToEmojiByThreadId[threadId]![emojiId] == true {
            return
        }
        
        self.gameDataStore.addEmojiByThreadId(access: self.userDataStore.token!.access, threadId: threadId, emojiId: emojiId, userId: self.userDataStore.token!.userId)
    }
    
    func onClickAddEmojiBubble() {
        self.gameDataStore.addEmojiThreadIdByForumId[self.gameDataStore.threads[self.threadId]!.forum.id] = self.threadId
        
        if self.isInThreadView == true {
            self.gameDataStore.isAddEmojiModalActiveByThreadViewId[self.threadId] = true
        } else {
            self.gameDataStore.isAddEmojiModalActiveByForumId[self.gameDataStore.threads[self.threadId]!.forum.id] = true
        }
    }
    
    func onClickEmoji(emojiId: Int) {
        // Upvote
        if emojiId == 0 {
            if self.gameDataStore.voteThreadMapping[threadId] != nil {
                if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 1 {
                    self.gameDataStore.deleteThreadVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!, userId: self.userDataStore.token!.userId)
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
                    self.gameDataStore.deleteThreadVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!, userId: self.userDataStore.token!.userId)
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
        
        if self.gameDataStore.didReactToEmojiByThreadId[threadId]![emojiId] == true {
            self.gameDataStore.removeEmojiByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId, emojiId: emojiId, userId: self.userDataStore.token!.userId)
        } else {
            self.gameDataStore.addEmojiByThreadId(access: self.userDataStore.token!.access, threadId: threadId, emojiId: emojiId, userId: self.userDataStore.token!.userId)
        }
    }
    
    var body: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading) {
                ForEach(self.gameDataStore.emojiArrByThreadId[self.threadId]!.indices, id: \.self) { row in
                    HStack {
                        ForEach(self.gameDataStore.emojiArrByThreadId[self.threadId]![row], id: \.self) { emojiId in
                            VStack {
                                if emojiId == 999 {
                                    HStack {
                                        Image(systemName: "plus.bubble.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .padding(.all, 5)
                                            .buttonStyle(PlainButtonStyle())
                                            .background(Color(red: 238 / 255, green: 238 / 255, blue: 238 / 255))
                                            .cornerRadius(5)
                                            .onTapGesture {
                                                self.onClickAddEmojiBubble()
                                        }
                                    }
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 5)
                                    .frame(alignment: .leading)
                                } else {
                                    HStack {
                                        Image(uiImage: self.gameDataStore.emojis[emojiId]!)
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                        
                                        Text(String(self.gameDataStore.emojiCountByThreadId[self.threadId]![emojiId]!))
                                    }
                                    .frame(width: 40, height: 20)
                                    .padding(5)
                                    .background(self.gameDataStore.didReactToEmojiByThreadId[self.threadId]![emojiId]! == true ? Color.gray : Color.white)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        self.onClickEmoji(emojiId: emojiId)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
