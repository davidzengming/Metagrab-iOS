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
    
    var ancestorThreadId: Int
    var commentId: Int
    let formatter = RelativeDateTimeFormatter()
    var width: CGFloat
    var height: CGFloat
    var leadPadding: CGFloat
    let staticPadding: CGFloat = 5
    let level: Int
    let leadLineWidth: CGFloat = 3
    let verticalPadding: CGFloat = 15
    
    @State var isEditable: Bool = false
    
    func setReplyTargetToCommentId() {
        self.gameDataStore.isReplyBarReplyingToThreadByThreadId[ancestorThreadId] = false
        self.gameDataStore.replyTargetCommentIdByThreadId[ancestorThreadId] = commentId
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
                                                Image(systemName: self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == 1 ? "hand.thumbsup.fill" : "hand.thumbsup")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .onTapGesture() {
                                                        self.onClickUpvoteButton()
                                                }
                                                Text(self.gameDataStore.commentsVoteStringByCommentId[self.commentId]!)
                                                    .font(.system(size: 14))
                                            }
                                            .frame(height: 16, alignment: .trailing)
                                            .padding(.trailing, 20)
                                            
                                            HStack {
                                                Image(systemName: self.gameDataStore.votes[self.gameDataStore.voteCommentMapping[commentId]!]!.direction == -1 ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .onTapGesture() {
                                                        self.onClickDownvoteButton()
                                                }
                                            }
                                            .frame(height: 16, alignment: .trailing)
                                        }
                                        Text(self.gameDataStore.relativeDateStringByCommentId[self.commentId]!)
                                            .foregroundColor(Color(.darkGray))
                                            .font(.system(size: 14))
                                            .padding(.bottom, 5)
                                    }
                                }
                                
                                if self.gameDataStore.commentsDesiredHeight[self.commentId] != nil {
                                    FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: self.$isEditable, isFirstResponder: .constant(false), didBecomeFirstResponder: .constant(false), showFancyPantsEditorBar: .constant(false), isNewContent: false, isThread: false, commentId: self.commentId, isOmniBar: false)
                                        .frame(width: self.width - self.leadPadding - staticPadding * 2 - 30 - 10 - (self.level > 0 ? 10 + self.leadLineWidth: 0), height: self.gameDataStore.commentsDesiredHeight[self.commentId]! + (self.isEditable ? 20 : 0), alignment: .leading)
                                    
                                        .onTapGesture {
                                            self.setReplyTargetToCommentId()
                                    }
                                }
                            }
                        }
                        .frame(width: self.width - self.leadPadding - staticPadding * 2 - (self.level > 0 ? 10 + self.leadLineWidth: 0), height: 30 + self.gameDataStore.commentsDesiredHeight[self.commentId]! + (self.isEditable ? 20 : 0), alignment: .leading)
                    }
                    .padding(.horizontal, self.staticPadding)
                    .padding(.vertical, self.verticalPadding)
                }
            }
            
            if self.gameDataStore.childCommentListByParentCommentId[self.commentId]!.count > 0 || (self.gameDataStore.moreCommentsByParentCommentId[self.commentId] != nil && self.gameDataStore.moreCommentsByParentCommentId[self.commentId]!.count > 0)  {
                VStack(alignment: .trailing, spacing: 0) {
                    if self.gameDataStore.moreCommentsByParentCommentId[self.commentId] != nil && self.gameDataStore.moreCommentsByParentCommentId[self.commentId]!.count > 0 {
                        MoreCommentsView(width: self.width - self.leadPadding - staticPadding * 2 - 10 - self.leadLineWidth - 20, commentId: self.commentId, leadLineWidth: self.leadLineWidth, staticPadding: self.staticPadding, verticalPadding: self.verticalPadding)
                    }
                    
                    ForEach(self.gameDataStore.childCommentListByParentCommentId[self.commentId]!, id: \.self) { key in
                        CommentView(ancestorThreadId: self.ancestorThreadId, commentId: key, width: self.width, height: self.height, leadPadding: self.leadPadding + 20, level: self.level + 1)
                    }
                }
            }
        }
        .onAppear() {
            if self.gameDataStore.commentNextPageStartIndex[self.commentId] != nil {
                return
            }
        }
    }
}
