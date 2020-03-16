//
//  MoreCommentsView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-03-11.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct MoreCommentsView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var width: CGFloat
    var commentId: Int
    var leadLineWidth: CGFloat
    var staticPadding: CGFloat
    var verticalPadding: CGFloat
    
    func getNumChildCommentsNotLoaded() -> Int {
        return self.gameDataStore.comments[self.commentId]!.numSubtreeNodes - self.gameDataStore.visibleChildCommentsNum[self.commentId]!
    }
    
    func getReplyPlurality() -> String {
        if self.gameDataStore.comments[self.commentId]!.numSubtreeNodes - self.gameDataStore.visibleChildCommentsNum[self.commentId]! > 1 {
            return "replies"
        }
        return "reply"
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchCommentTreeByParentComment(access: self.userDataStore.token!.access, parentCommentId: commentId, start: self.gameDataStore.commentNextPageStartIndex[commentId]!)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color(red: 225 / 255, green: 225 / 255, blue: 225 / 255))
            .frame(width: self.width + self.staticPadding * 2 + 10 + self.leadLineWidth, height: 1, alignment: .leading)
            
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.red)
                    .frame(width: self.leadLineWidth, height: 20)
                    .padding(.trailing, 10)
                
                HStack(spacing: 0) {
                    Text("See \(self.getNumChildCommentsNotLoaded()) more \(self.getReplyPlurality())")
                        .padding(.leading, 10)
                    Spacer()
                    Image(systemName: "chevron.compact.down")
                }
                .frame(width: self.width, height: 20, alignment: .leading)
                .onTapGesture() {
                    self.fetchNextPage()
                }
//                .background(Color.green)
                .padding(.horizontal, self.staticPadding)
                .padding(.vertical, self.verticalPadding)
//                .background(Color.white)
                
            }
        }
    }
}
