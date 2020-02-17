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
    let formatter = RelativeDateTimeFormatter()
    
    @State var replyBoxOpen: Bool = false
    @State var isEditable = false
    @State var replyContent = NSTextStorage(string: "")
    @State var test = NSTextStorage(string: "")
    @State var desiredHeight: CGFloat = 0
    
    func toggleReplyBoxOpen() {
        self.replyBoxOpen = !self.replyBoxOpen
    }
    
    func postPrimaryComment() {
        self.gameDataStore.postMainComment(access: self.userDataStore.token!.access, threadId: threadId, content: replyContent)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchCommentTreeByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId, start: self.gameDataStore.threadsNextPageStartIndex[threadId]!)
    }
    
    func getRelativeDate(postedDate: Date) -> String {
        return formatter.localizedString(for: postedDate, relativeTo: Date())
    }
    
    func toggleEditMode() {
        self.isEditable = !self.isEditable
    }
    
    var body: some View {
        VStack {
            ScrollView() {
                VStack {
                    Text(getRelativeDate(postedDate: self.gameDataStore.threads[threadId]!.created))
                    Text(self.gameDataStore.users[self.gameDataStore.threads[threadId]!.author]!.username)
                    
                    if (self.gameDataStore.threadsImage[threadId] != nil) {
                        Image(uiImage: self.gameDataStore.threadsImage[threadId]!)
                            .resizable()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                            .aspectRatio(contentMode:.fit)
                            .padding(5)
                    } else {
                        FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: $isEditable, isNewContent: false, isThread: true, threadId: threadId, isFirstResponder: false)
                            .frame(width: 300, height: self.desiredHeight)
                        Button(action: toggleEditMode) {
                            Text("Edit Thread")
                        }
                    }
                    
                    Button(action: toggleReplyBoxOpen) {
                        Text("Reply")
                    }
                    
                    if self.replyBoxOpen {
                        VStack {
                            FancyPantsEditorView(newTextStorage: $replyContent, isEditable: .constant(true), isNewContent: true, isThread: false, isFirstResponder: false)
                            .background(Color.white)
                            .cornerRadius(5)
                            .overlay(RoundedRectangle(cornerRadius: 3)
                                     .stroke(Color.black, lineWidth: 1))
                            .padding(.horizontal, 10)
                            
                            HStack {
                                Spacer()
                                Button(action: postPrimaryComment) {
                                    Text("Submit")
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    VStack {
                        ForEach(self.gameDataStore.mainCommentListByThreadId[threadId]!, id: \.self) { key in
                            CommentView(commentId: key)
                        }
                    }
                    .padding(5)
                }
                
            }
            
            if self.gameDataStore.moreCommentsByThreadId[threadId] != nil && self.gameDataStore.moreCommentsByThreadId[threadId]!.count > 0 {
                Button(action: fetchNextPage) {
                    Text("More comments ->")
                }
            }
            
        }.onAppear() {

            self.gameDataStore.fetchCommentTreeByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId, refresh: true)
            self.gameDataStore.loadThreadIcon(thread: self.gameDataStore.threads[self.threadId]!)
        }
        .navigationBarTitle(Text(self.gameDataStore.threads[threadId]!.title))
    }
}
