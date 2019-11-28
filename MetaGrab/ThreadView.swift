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
        self.gameDataStore.postMainComment(access: self.userDataStore.token!.access, threadId: threadId, text: text)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchCommentTreeByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId, start: self.gameDataStore.threadsNextPageStartIndex[threadId]!)
    }
    
    var body: some View {
        VStack {
            HStack {
                if (self.gameDataStore.threadsImage[threadId] != nil) {
                    Image(uiImage: self.gameDataStore.threadsImage[threadId]!)
                        .resizable()
                        .frame(width: 100, height: 75)
                } else {
                    self.placeholder
                        .frame(width: 100, height: 75)
                }

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
            
            ScrollView() {
                HStack {
                    Text("Thread")
                        .font(.headline)
                    Spacer()
                }
                VStack {
                    Spacer().frame(height: 160)
                    ForEach(self.gameDataStore.mainCommentListByThreadId[threadId]!, id: \.self) { key in
                        HStack {
                            self.placeholder.frame(width: 100, height: 75)
                            CommentView(commentId: key)
                        }
                    }
                }.scaledToFill()
            }
            
            if self.gameDataStore.moreCommentsByThreadId[threadId] != nil && self.gameDataStore.moreCommentsByThreadId[threadId]!.count > 0 {
                Button(action: fetchNextPage) {
                    Text("More comments ->")
                }
            }
            
        }.onAppear() {
            self.gameDataStore.fetchCommentTreeByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId)
            self.gameDataStore.loadThreadIcon(thread: self.gameDataStore.threads[self.threadId]!)
        }
        .navigationBarTitle(Text(self.gameDataStore.threads[threadId]!.title))
    }
}
