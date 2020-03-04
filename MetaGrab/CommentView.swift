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
    var width: CGFloat
    var height: CGFloat
    var leadPadding: CGFloat
    
    @State var replyBoxOpen: Bool = false
    @State var replyContent: NSTextStorage = NSTextStorage(string: "")
    @State var isEditable: Bool = false
    @State var desiredHeight: CGFloat = 0
    
    func isVotedUp() -> Bool {
        return self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == 1
    }
    
    func isVotedDown() -> Bool {
        return self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == -1
    }
    
    func toggleReplyBoxOpen() {
        self.replyBoxOpen = !self.replyBoxOpen
    }
    
    func postChildComment() {
        self.gameDataStore.postChildComment(access: self.userDataStore.token!.access, parentCommentId: commentId, content: replyContent)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchCommentTreeByParentComment(access: self.userDataStore.token!.access, parentCommentId: commentId, start: self.gameDataStore.commentNextPageStartIndex[commentId]!)
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
        
        return ((isNegative ? "-" : "") + concatVotesStr)
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
        VStack(alignment: .trailing, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(self.gameDataStore.users[self.gameDataStore.comments[self.commentId]!.author]!.username)
                    .frame(width: self.width - self.leadPadding, height: self.height * 0.025, alignment: .leading)
                Text(self.getRelativeDate(postedDate: self.gameDataStore.comments[self.commentId]!.created))
                    .frame(width: self.width - self.leadPadding, height: self.height * 0.025, alignment: .leading)
                if self.gameDataStore.commentsDesiredHeight[self.commentId] != nil {
                    FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: self.$isEditable, isNewContent: false, isThread: false, commentId: self.commentId, isFirstResponder: false)
                        .frame(width: self.width - self.leadPadding, height: self.gameDataStore.commentsDesiredHeight[self.commentId]!, alignment: .leading)
                        .background(Color.blue)
                }
                
                HStack {
                    Image(uiImage: UIImage(systemName: "arrowshape.turn.up.right.fill")!)
                        .onTapGesture() {
                            self.toggleReplyBoxOpen()
                    }
                    .frame(width: self.width * 0.2, height: self.height * 0.05, alignment: .center)
                    
                    HStack {
                        Image(uiImage: UIImage(systemName: self.isVotedUp() ? "hand.thumbsup.fill" : "hand.thumbsup")!)
                            .onTapGesture() {
                                self.onClickUpvoteButton()
                        }
                        Text(self.transformVotesString(points: self.gameDataStore.comments[self.commentId]!.upvotes))
                            .font(.system(size: 12))
                    }
                    .frame(width: self.width * 0.2, height: self.height * 0.05, alignment: .center)
                    
                    HStack{
                        Image(uiImage: UIImage(systemName: self.isVotedDown() ? "hand.thumbsdown.fill" : "hand.thumbsdown")!)
                            .onTapGesture() {
                                self.onClickDownvoteButton()
                        }
                        Text(self.transformVotesString(points: self.gameDataStore.comments[self.commentId]!.downvotes))
                            .font(.system(size: 12))
                    }
                    .frame(width: self.width * 0.2, height: self.height * 0.05, alignment: .center)
                }
                
                if self.replyBoxOpen {
                    VStack {
                        FancyPantsEditorView(newTextStorage: self.$replyContent, isEditable: .constant(true), isNewContent: true, isThread: false, isFirstResponder: false)
                            .cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.black, lineWidth: 1))
                            .frame(width: (self.width - self.leadPadding) * 0.9, height: self.height * 0.15, alignment: .leading)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: self.postChildComment) {
                            Text("Submit")
                        }
                    }
                    .frame(width: self.width * 0.2, height: self.height * 0.05, alignment: .trailing)
                }
            }
            .background(Color.white)
            
            HStack {
                if self.gameDataStore.childCommentListByParentCommentId[self.commentId]!.count > 0 {
                    VStack(alignment: .trailing, spacing: 0) {
                        ForEach(self.gameDataStore.childCommentListByParentCommentId[self.commentId]!, id: \.self) { key in
                            CommentView(commentId: key, width: self.width, height: self.height, leadPadding: self.leadPadding + 10)
                        }
                    }
                }
            }
            .background(Color.white)
            
            if self.gameDataStore.moreCommentsByParentCommentId[self.commentId] != nil && self.gameDataStore.moreCommentsByParentCommentId[self.commentId]!.count > 0 {
                Button(action: self.fetchNextPage) {
                    Text("Load more comments")
                }
                .background(Color.white)
                .frame(width: 200, height: self.height * 0.05, alignment: .center)
            }
            
        }
        .background(Color.orange)
        .onAppear() {
            if self.gameDataStore.commentNextPageStartIndex[self.commentId] != nil {
                return
            }
        }
    }
}
