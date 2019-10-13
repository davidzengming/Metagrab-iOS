//
//  ThreadView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-22.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI

struct ThreadView : View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    var threadId: Int
    let placeholder = Image(systemName: "photo")
    @State var replyBoxOpen: Bool = false
    @State var text: String = ""
    
    
    func toggleReplyBoxOpen() {
        self.replyBoxOpen = !self.replyBoxOpen
    }
    
    func postPrimaryComment() {
        self.gameDataStore.postPrimaryComment(access: self.userDataStore.token!.access, threadId: threadId, text: text)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchPrimaryComments(access: self.userDataStore.token!.access, threadId: threadId, fetchNextPage: true)
    }
    
    var body: some View {
        VStack {
            HStack {
                self.placeholder
                    .frame(width: 100, height: 75)
                Text(self.gameDataStore.threads[threadId]!.content)
                Spacer()
                Button(action: toggleReplyBoxOpen) {
                    Text("Reply")
                }
            }
            if self.replyBoxOpen {
                TextField("Reply", text: $text)
                    .padding(.leading, 50)
                Button(action: postPrimaryComment) {
                    Text("Submit")
                }
            }
            Divider()
            List(self.gameDataStore.primaryCommentListByThreadId[threadId]!, id: \.self) { key in
                HStack {
                    self.placeholder
                        .frame(width: 100, height: 75)
                    CommentView(commentId: key)
                }
            }
            if self.gameDataStore.primaryCommentsCursorByThreadId[threadId] != nil {
                Button(action: fetchNextPage) {
                    Text("More comments")
                }
            }
            
        }.onAppear() {
            self.gameDataStore.fetchPrimaryComments(access: self.userDataStore.token!.access, threadId: self.threadId)
        }
        .navigationBarTitle(Text(self.gameDataStore.threads[threadId]!.title))
    }
}
