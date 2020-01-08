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
    @State var text: NSMutableString = ""
    @State var isBold: Bool = false
    @State var isNumberedBulletList = false
    @State var didChangeBold = false
    @State var didChangeNumberedBulletList = false
    
    func toggleReplyBoxOpen() {
        self.replyBoxOpen = !self.replyBoxOpen
    }
    
    func postPrimaryComment() {
        self.gameDataStore.postMainComment(access: self.userDataStore.token!.access, threadId: threadId, text: text as String)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchCommentTreeByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId, start: self.gameDataStore.threadsNextPageStartIndex[threadId]!)
    }
    
    func getRelativeDate(postedDate: Date) -> String {
        return formatter.localizedString(for: postedDate, relativeTo: Date())
    }
    
    var body: some View {
        VStack {
            ScrollView() {
                VStack {
                    Text(getRelativeDate(postedDate: self.gameDataStore.threads[threadId]!.created))
                    Text(self.gameDataStore.users[self.gameDataStore.threads[threadId]!.author]!.username)
                    Text(self.gameDataStore.threads[threadId]!.content)
                    if (self.gameDataStore.threadsImage[threadId] != nil) {
                        Image(uiImage: self.gameDataStore.threadsImage[threadId]!)
                            .resizable()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                            .aspectRatio(contentMode:.fit)
                            .padding(5)
                    }
                    Button(action: toggleReplyBoxOpen) {
                        Text("Reply")
                    }
                    
                    if self.replyBoxOpen {
                        VStack {
                            FancyPantsEditorBarView(isBold: $isBold, isNumberedBulletList: $isNumberedBulletList, didChangeBold: $didChangeBold, didChangeNumberedBulletList: $didChangeNumberedBulletList)
                            TextView(text: $text, isBold: $isBold, isNumberedBulletList: $isNumberedBulletList, didChangeBold: $didChangeBold, didChangeNumberedBulletList: $didChangeNumberedBulletList, textStorage: NSTextStorage())
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100)
                            .background(Color.white)
                            .cornerRadius(5 )
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
