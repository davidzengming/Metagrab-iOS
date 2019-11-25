//
//  CommentView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-22.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation

import Foundation
import SwiftUI

struct CommentView : View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    var commentId: Int
    @State var replyBoxOpen: Bool = false
    @State var text: String = ""
    
    func toggleReplyBoxOpen() {
        self.replyBoxOpen = !self.replyBoxOpen
    }
    
    func postChildComment() {
        self.gameDataStore.postChildComment(access: self.userDataStore.token!.access, parentCommentId: commentId, text: text)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchCommentTreeByParentComment(access: self.userDataStore.token!.access, parentCommentId: commentId, start: self.gameDataStore.commentNextPageStartIndex[commentId]!)
    }
    
    func onClickUpvoteButton() {
        if self.gameDataStore.voteCommentMapping[commentId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.isPositive == true {
                            self.gameDataStore.deleteCommentVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!)
            } else {
                self.gameDataStore.switchUpvoteComment(access: self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!)
            }
        } else {
            self.gameDataStore.upvoteComment(access: self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!)
        }
    }
    
    func onClickDownvoteButton() {
        if self.gameDataStore.voteCommentMapping[commentId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.isPositive == false {
                self.gameDataStore.deleteCommentVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!)
            } else {
                self.gameDataStore.switchDownvoteComment(access:  self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!)
            }
        } else {
            self.gameDataStore.downvoteComment(access: self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    if self.gameDataStore.voteCommentMapping[commentId] != nil {
                        Text("Hi I voted on this")
                    }
                    Button(action: onClickUpvoteButton) {
                        Text("👍")
                    }
                    Text(String(self.gameDataStore.comments[commentId]!.upvotes - self.gameDataStore.comments[commentId]!.downvotes))
                    Button(action: onClickDownvoteButton) {
                        Text("👎")
                    }
                }
                
                Text(self.gameDataStore.comments[self.commentId]!.content)
                    .font(.subheadline)
                Spacer()
                Button(action: toggleReplyBoxOpen) {
                    Text("Reply")
                }
                
            }
            
            ForEach(self.gameDataStore.childCommentListByParentCommentId[self.commentId]!, id: \.self) { key in
                VStack {
                    CommentView(commentId: key)
                    Spacer()
                }
            }
            
            if self.gameDataStore.moreCommentsByParentCommentId[commentId] != nil && self.gameDataStore.moreCommentsByParentCommentId[commentId]!.count > 0 {
                Button(action: fetchNextPage) {
                    Text("Load more comments")
                }
            }
            
            if self.replyBoxOpen {
                TextField("Reply", text: $text)
                    .padding(.leading, 50)
                Button(action: postChildComment) {
                    Text("Submit")
                }
            }
        }
        .padding(.leading, 20)
        .onAppear() {
            if self.gameDataStore.commentNextPageStartIndex[self.commentId] != nil {
                return
            }
            self.gameDataStore.fetchChildComments(access: self.userDataStore.token!.access, parentCommentId: self.commentId)
        }
    }
}
