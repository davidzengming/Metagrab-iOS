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
    let staticPadding: CGFloat = 5
    let level: Int
    let leadLineWidth: CGFloat = 5
    let verticalPadding: CGFloat = 15
    
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
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(red: 225 / 255, green: 225 / 255, blue: 225 / 255))
                .frame(width: self.width - self.leadPadding, height: 1, alignment: .leading)
                
                HStack(spacing: 0) {
                    if self.level > 0 {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.red)
                            .frame(width: self.leadLineWidth, height: 30 + self.gameDataStore.commentsDesiredHeight[self.commentId]! + (self.isEditable ? 20 : 0))
                            .padding(.trailing, 10)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .trailing, spacing: 0) {
                            VStack(alignment: .trailing, spacing: 0) {
                                HStack(spacing: 0) {
                                    VStack(spacing: 0) {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color.orange)
                                    }
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 10)
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(spacing: 0) {
                                            Text(self.gameDataStore.users[self.gameDataStore.comments[self.commentId]!.author]!.username)
                                                .font(.system(size: 16))
                                            Spacer()
                                            
                                            HStack {
                                                Image(systemName: self.isVotedUp() ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .onTapGesture() {
                                                        self.onClickUpvoteButton()
                                                }
                                                Text(self.transformVotesString(points: self.gameDataStore.comments[self.commentId]!.upvotes))
                                                    .font(.system(size: 14))
                                            }
                                            .frame(height: 16, alignment: .trailing)
                                            .padding(.trailing, 20)
                                            
                                            HStack {
                                                Image(systemName: self.isVotedDown() ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .onTapGesture() {
                                                        self.onClickDownvoteButton()
                                                }
                                            }
                                            .frame(height: 16, alignment: .trailing)
                                        }
                                        Text(self.getRelativeDate(postedDate: self.gameDataStore.comments[self.commentId]!.created))
                                            .foregroundColor(Color(.darkGray))
                                            .font(.system(size: 14))
                                            .padding(.bottom, 5)
                                    }
                                }
                                
                                if self.gameDataStore.commentsDesiredHeight[self.commentId] != nil {
                                    FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: self.$isEditable, isNewContent: false, isThread: false, commentId: self.commentId, isFirstResponder: false)
                                        .frame(width: self.width - self.leadPadding - staticPadding * 2 - 30 - 10 - (self.level > 0 ? 10 + self.leadLineWidth: 0), height: self.gameDataStore.commentsDesiredHeight[self.commentId]! + (self.isEditable ? 20 : 0), alignment: .leading)
                                        .onTapGesture() {
                                            self.toggleReplyBoxOpen()
                                    }
                                }
                            }
                        }
                        .frame(width: self.width - self.leadPadding - staticPadding * 2 - (self.level > 0 ? 10 + self.leadLineWidth: 0), height: 30 + self.gameDataStore.commentsDesiredHeight[self.commentId]! + (self.isEditable ? 20 : 0), alignment: .leading)
//                        .background(Color.purple)
                        
                        if self.replyBoxOpen {
                            VStack(spacing: 0) {
                                FancyPantsEditorView(newTextStorage: self.$replyContent, isEditable: .constant(true), isNewContent: true, isThread: false, isFirstResponder: false)
                                    .cornerRadius(5)
                                    .overlay(RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.black, lineWidth: 1))
                                    .frame(width: self.width - self.leadPadding - staticPadding * 2 - 10 - self.leadLineWidth, height: 100, alignment: .leading)
                            }
                            
                            HStack {
                                Button(action: self.postChildComment) {
                                    Text("Submit")
                                }
                            }
                            .frame(width: self.width * 0.2, height: 20, alignment: .trailing)
                        }
                    }
                    .padding(.horizontal, self.staticPadding)
                    .padding(.vertical, self.verticalPadding)
//                    .background(Color.white)
                }
            }
            
            if self.gameDataStore.childCommentListByParentCommentId[self.commentId]!.count > 0 || (self.gameDataStore.moreCommentsByParentCommentId[self.commentId] != nil && self.gameDataStore.moreCommentsByParentCommentId[self.commentId]!.count > 0)  {
                VStack(alignment: .trailing, spacing: 0) {
                    if self.gameDataStore.moreCommentsByParentCommentId[self.commentId] != nil && self.gameDataStore.moreCommentsByParentCommentId[self.commentId]!.count > 0 {
                        MoreCommentsView(width: self.width - self.leadPadding - staticPadding * 2 - 10 - self.leadLineWidth - 20, commentId: self.commentId, leadLineWidth: self.leadLineWidth, staticPadding: self.staticPadding, verticalPadding: self.verticalPadding)
                    }
                    
                    ForEach(self.gameDataStore.childCommentListByParentCommentId[self.commentId]!, id: \.self) { key in
                        CommentView(commentId: key, width: self.width, height: self.height, leadPadding: self.leadPadding + 20, level: self.level + 1)
                    }
                }
            }
        }
//        .background(Color.yellow)
        .onAppear() {
            if self.gameDataStore.commentNextPageStartIndex[self.commentId] != nil {
                return
            }
        }
    }
}
