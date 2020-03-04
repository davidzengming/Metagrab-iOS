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
        GeometryReader { a in
            VStack {
                ScrollView() {
                    VStack(alignment: .leading) {
                        Text(self.getRelativeDate(postedDate: self.gameDataStore.threads[self.threadId]!.created))
                            .frame(width: a.size.width, height: a.size.height * 0.025, alignment: .leading)
                        Text(self.gameDataStore.users[self.gameDataStore.threads[self.threadId]!.author]!.username)
                            .frame(width: a.size.width, height: a.size.height * 0.025, alignment: .leading)
                        
                        FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: self.$isEditable, isNewContent: false, isThread: true, threadId: self.threadId, isFirstResponder: false)
                            .frame(width: a.size.width, height: self.gameDataStore.threadsDesiredHeight[self.threadId]!)
                        
                        if (self.gameDataStore.threadsImages[self.threadId] != nil) {
                            HStack(spacing: 0) {
                                ForEach(self.gameDataStore.threadsImages[self.threadId]!, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(5)
                                        .frame(minWidth: a.size.width * 0.05, maxWidth: a.size.width * 0.25, minHeight: a.size.height * 0.1, maxHeight: a.size.height * 0.15)
                                        .background(Color.pink)
                                        .padding(5)
                                }
                            }
                        }
                        
                        HStack {
                            Button(action: self.toggleEditMode) {
                                Text("Edit Thread")
                            }
                            Button(action: self.toggleReplyBoxOpen) {
                                Text("Reply")
                            }
                        }
                        .frame(width: a.size.width, height: a.size.height * 0.05, alignment: .leading)
                        
                        if self.replyBoxOpen {
                            VStack {
                                FancyPantsEditorView(newTextStorage: self.$replyContent, isEditable: .constant(true), isNewContent: true, isThread: false, isFirstResponder: false)
                                    .cornerRadius(5)
                                    .overlay(RoundedRectangle(cornerRadius: 3)
                                    .stroke(Color.black, lineWidth: 1))
                                    .frame(width: a.size.width * 0.9, height: a.size.height * 0.15)
                                
                                HStack {
                                    Spacer()
                                    Button(action: self.postPrimaryComment) {
                                        Text("Submit")
                                    }
                                }
                                .frame(width: a.size.width, height: a.size.height * 0.05, alignment: .center)
                            }
                        }
                        
                        if !self.gameDataStore.mainCommentListByThreadId[self.threadId]!.isEmpty {
                            ForEach(self.gameDataStore.mainCommentListByThreadId[self.threadId]!, id: \.self) { commentId in
                                CommentView(commentId: commentId, width: a.size.width, height: a.size.height, leadPadding: 0)
                            }
                        }
                    }
                }
                
                if self.gameDataStore.moreCommentsByThreadId[self.threadId] != nil && self.gameDataStore.moreCommentsByThreadId[self.threadId]!.count > 0 {
                    Button(action: self.fetchNextPage) {
                        Text("More comments ->")
                    }
                    .frame(width: a.size.width, height: a.size.height * 0.05, alignment: .leading)
                }
            }
        }.onAppear() {
            self.gameDataStore.fetchCommentTreeByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId, refresh: true)
            self.gameDataStore.loadThreadIcons(thread: self.gameDataStore.threads[self.threadId]!)
        }
        .navigationBarTitle(Text(self.gameDataStore.threads[threadId]!.title))
    }
}
