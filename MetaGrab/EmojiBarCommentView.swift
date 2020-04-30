////
////  EmojiBarCommentView.swift
////  MetaGrab
////
////  Created by David Zeng on 2020-04-15.
////  Copyright © 2020 David Zeng. All rights reserved.
////
//
//import SwiftUI
//
//struct EmojiBarCommentView: View {
//    @EnvironmentObject var gameDataStore: GameDataStore
//    @EnvironmentObject var userDataStore: UserDataStore
//
//    var commentId: Int
//    var ancestorThreadId: Int
//    let numEmojisShown = 3
//    
//    func addEmoji(emojiId: Int) {
//        if self.gameDataStore.didReactToEmojiByCommentId[commentId]![emojiId] == true {
//            return
//        }
//
//        self.gameDataStore.addEmojiByCommentId(access: self.userDataStore.token!.access, commentId: commentId, emojiId: emojiId, userId: self.userDataStore.token!.userId)
//    }
//
//    func onClickAddEmojiBubble() {
//        self.gameDataStore.addEmojiViewLastClickedIsThread[self.ancestorThreadId] = false
//        self.gameDataStore.addEmojiCommentIdByThreadId[self.ancestorThreadId] = self.commentId
//        self.gameDataStore.isAddEmojiModalActiveByThreadViewId[self.ancestorThreadId] = true
//    }
//
//    func onClickEmoji(emojiId: Int) {
//        // Upvote
//        if emojiId == 0 {
//            if self.gameDataStore.voteCommentMapping[commentId] != nil {
//                if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == 1 {
//                    self.gameDataStore.deleteCommentVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!, userId: self.userDataStore.token!.userId)
//                } else if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == 0 {
//                    self.gameDataStore.upvoteByExistingVoteIdComment(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteCommentMapping[commentId]!, comment: self.gameDataStore.comments[commentId]!, userId: self.userDataStore.token!.userId)
//                } else {
//                    self.gameDataStore.switchUpvoteComment(access: self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!, userId: self.userDataStore.token!.userId)
//                }
//            } else {
//                self.gameDataStore.addNewUpvoteComment(access: self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!, userId: self.userDataStore.token!.userId)
//            }
//            return
//        }
//
//        // Downvote
//        if emojiId == 1 {
//            if self.gameDataStore.voteCommentMapping[commentId] != nil {
//                if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == -1 {
//                    self.gameDataStore.deleteCommentVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!, userId: self.userDataStore.token!.userId)
//                } else if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == 0 {
//                    self.gameDataStore.downvoteByExistingVoteIdComment(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteCommentMapping[commentId]!, comment: self.gameDataStore.comments[commentId]!, userId: self.userDataStore.token!.userId)
//                } else {
//                    self.gameDataStore.switchDownvoteComment(access:  self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!, userId: self.userDataStore.token!.userId)
//                }
//            } else {
//                self.gameDataStore.addNewDownvoteComment(access: self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!, userId: self.userDataStore.token!.userId)
//            }
//            return
//        }
//
//        if self.gameDataStore.didReactToEmojiByCommentId[commentId]![emojiId] == true {
//            self.gameDataStore.removeEmojiByCommentId(access: self.userDataStore.token!.access, commentId: self.commentId, emojiId: emojiId, userId: self.userDataStore.token!.userId)
//        } else {
//            self.gameDataStore.addEmojiByCommentId(access: self.userDataStore.token!.access, commentId: commentId, emojiId: emojiId, userId: self.userDataStore.token!.userId)
//        }
//    }
//
//    var body: some View {
//        ForEach(self.gameDataStore.emojiArrByCommentId[self.commentId]![0].prefix(self.numEmojisShown), id: \.self) { emojiId in
//            VStack {
//                if emojiId == 999 {
//                    HStack {
//                        Image(systemName: "plus.bubble.fill")
//                            .resizable()
//                            .frame(width: 20, height: 20)
//                            .padding(.all, 5)
//                            .buttonStyle(PlainButtonStyle())
//                            .background(Color(red: 238 / 255, green: 238 / 255, blue: 238 / 255))
//                            .cornerRadius(5)
//                            .onTapGesture {
//                                self.onClickAddEmojiBubble()
//                        }
//                    }
//                    .padding(.vertical, 2)
//                    .padding(.horizontal, 5)
//                    .frame(alignment: .leading)
//                } else {
//                    HStack {
//                        Image(uiImage: self.gameDataStore.emojis[emojiId]!)
//                            .resizable()
//                            .frame(width: 15, height: 15)
//
//                        Text(String(self.gameDataStore.emojiCountByCommentId[self.commentId]![emojiId]!))
//                    }
//                    .frame(width: 40, height: 20)
//                    .padding(5)
//                    .background(self.gameDataStore.didReactToEmojiByCommentId[self.commentId]![emojiId]! == true ? Color.gray : Color(.lightGray))
//                    .cornerRadius(5)
//                    .onTapGesture {
//                        self.onClickEmoji(emojiId: emojiId)
//                    }
//                }
//            }
//        }
//
//    }
//}
