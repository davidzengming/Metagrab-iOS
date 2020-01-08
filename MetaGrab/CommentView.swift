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
    let formatter = RelativeDateTimeFormatter()
    @State var replyBoxOpen: Bool = false
    @State var text: NSMutableString = ""
    @State var isBold: Bool = false
    @State var isNumberedBulletList = false
    @State var didChangeBold = false
    @State var didChangeNumberedBulletList = false
    
    func toggleReplyBoxOpen() {
        self.replyBoxOpen = !self.replyBoxOpen
    }
    
    func postChildComment() {
        self.gameDataStore.postChildComment(access: self.userDataStore.token!.access, parentCommentId: commentId, text: text as String)
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
    
    func doSomething() {
        print("Hello world!")
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(getRelativeDate(postedDate: self.gameDataStore.comments[commentId]!.created))
                Text(self.gameDataStore.users[self.gameDataStore.comments[commentId]!.author]!.username)
                Text(self.gameDataStore.comments[self.commentId]!.content)
                
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
                        FancyPantsEditorBarView(isBold: $isBold, isNumberedBulletList: $isNumberedBulletList, didChangeBold: $didChangeBold, didChangeNumberedBulletList: $didChangeNumberedBulletList)
                        TextView(text: $text, isBold: $isBold, isNumberedBulletList: $isNumberedBulletList, didChangeBold: $didChangeBold, didChangeNumberedBulletList: $didChangeNumberedBulletList, textStorage: NSTextStorage())
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 100)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 3)
                                 .stroke(Color.black, lineWidth: 1))
                        .padding(.horizontal, 10)
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
