//
//  CommentView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-22.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI

struct CommentView : View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    var commentId: Int
    let formatter = RelativeDateTimeFormatter()
    @State var replyBoxOpen: Bool = false
    @State var replyContent: NSTextStorage = NSTextStorage(string: "")
    @State var isEditable: Bool = false
    @State var desiredHeight: CGFloat = 0
    
    func toggleReplyBoxOpen() {
        self.replyBoxOpen = !self.replyBoxOpen
    }
    
    func postChildComment() {
        self.gameDataStore.postChildComment(access: self.userDataStore.token!.access, parentCommentId: commentId, content: replyContent)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchCommentTreeByParentComment(access: self.userDataStore.token!.access, parentCommentId: commentId, start: self.gameDataStore.commentNextPageStartIndex[commentId]!)
    }
    
    func onClickUpvoteButton() {
        if self.gameDataStore.voteCommentMapping[commentId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == 1 {
                            self.gameDataStore.deleteCommentVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!)
            }  else if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == 0 {
                self.gameDataStore.upvoteByExistingVoteIdComment(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteCommentMapping[commentId]!, comment: self.gameDataStore.comments[commentId]!)
            } else {
                self.gameDataStore.switchUpvoteComment(access: self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!)
            }
        } else {
            self.gameDataStore.addNewUpvoteComment(access: self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!)
        }
    }
    
    func onClickDownvoteButton() {
        if self.gameDataStore.voteCommentMapping[commentId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == -1 {
                self.gameDataStore.deleteCommentVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!)
            } else if self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == 0 {
                self.gameDataStore.downvoteByExistingVoteIdComment(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteCommentMapping[commentId]!, comment: self.gameDataStore.comments[commentId]!)
            } else {
                self.gameDataStore.switchDownvoteComment(access:  self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!)
            }
        } else {
            self.gameDataStore.addNewDownvoteComment(access: self.userDataStore.token!.access, comment: self.gameDataStore.comments[commentId]!)
        }
    }
    
    func getRelativeDate(postedDate: Date) -> String {
        return formatter.localizedString(for: postedDate, relativeTo: Date())
    }
    
    
    var body: some View {
        VStack {
            VStack {
                Text(getRelativeDate(postedDate: self.gameDataStore.comments[commentId]!.created))
                Text(self.gameDataStore.users[self.gameDataStore.comments[commentId]!.author]!.username)
                
                if self.gameDataStore.commentsTextStorage[self.commentId] != nil {
                    FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: $isEditable, isNewContent: false, isThread: false, commentId: self.commentId, isFirstResponder: false)
                }
                
                HStack {
                    Button(action: toggleReplyBoxOpen) {
                        Text("Reply")
                    }
                    Spacer()
                    if self.gameDataStore.voteCommentMapping[commentId] != nil {
                        Text("Hi I voted on this")
                    }
                    
                    HStack {
                        Button(action: onClickUpvoteButton) {
                            Text("👍")
                        }
                        Text(String(self.gameDataStore.comments[commentId]!.upvotes - self.gameDataStore.comments[commentId]!.downvotes))
                        Button(action: onClickDownvoteButton) {
                            Text("👎")
                        }
                    }
                    .frame(width: 100)
                }

                if self.replyBoxOpen {
                    VStack {
                        FancyPantsEditorView(newTextStorage: $replyContent, isEditable: .constant(true), isNewContent: true, isThread: false, isFirstResponder: false)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: postChildComment) {
                            Text("Submit")
                        }
                    }
                }
            }
            .padding(.leading, 5)
            .background(Color.green)
            
            HStack {
                if self.gameDataStore.childCommentListByParentCommentId[self.commentId]!.count > 0 {
                    VStack {
                        ForEach(self.gameDataStore.childCommentListByParentCommentId[self.commentId]!, id: \.self) { key in
                            CommentView(commentId: key)
                        }
                    }.padding(.leading, 5)
                }
            }
            .padding(.leading, 5)
            if self.gameDataStore.moreCommentsByParentCommentId[commentId] != nil && self.gameDataStore.moreCommentsByParentCommentId[commentId]!.count > 0 {
                Button(action: fetchNextPage) {
                    Text("Load more comments")
                }
                .background(Color.pink)
            }
        }
        .background(Color.blue)
        .onAppear() {
            if self.gameDataStore.commentNextPageStartIndex[self.commentId] != nil {
                return
            }
        }
    }
}
