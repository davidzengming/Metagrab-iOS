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
    
    func postSecondaryComment() {
        self.gameDataStore.postSecondaryComment(access: self.userDataStore.token!.access, primaryCommentId: commentId, text: text)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchSecondaryComments(access: self.userDataStore.token!.access, primaryCommentId: commentId, fetchNextPage: true)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(self.gameDataStore.primaryComments[self.commentId]!.content)
                    .font(.subheadline)
                Spacer()
                Button(action: toggleReplyBoxOpen) {
                    Text("Reply")
                }
            }
            VStack {
                List(self.gameDataStore.secondaryCommentListByPrimeCommentId[self.commentId]!, id: \.self) { key in
                    HStack {
                        Text(self.gameDataStore.secondaryComments[key]!.content)
                        Spacer()
                    }.padding(.leading, 50)
                }
            }
            
            if self.gameDataStore.secondaryCommentsCursorByPrimaryCommentId[self.commentId] != nil {
                Button(action: fetchNextPage) {
                    Text("More comments")
                }
            }
            
            if self.replyBoxOpen {
                TextField("Reply", text: $text)
                    .padding(.leading, 50)
                Button(action: postSecondaryComment) {
                    Text("Submit")
                }
            }
        }.onAppear() {
            self.gameDataStore.fetchSecondaryComments(access: self.userDataStore.token!.access, primaryCommentId: self.commentId)
        }
    }
}
