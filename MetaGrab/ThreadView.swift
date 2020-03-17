//
//  ThreadView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-22.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct KeyboardAwareModifier: ViewModifier {
    @EnvironmentObject var gameDataStore: GameDataStore
    
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.gameDataStore.keyboardHeight)
            .edgesIgnoringSafeArea(self.gameDataStore.keyboardHeight == 0 ? [] : .bottom)
            .onReceive(keyboardHeightPublisher) {
                self.gameDataStore.keyboardHeight = $0
        }
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ThreadView : View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var threadId: Int
    let placeholder = Image(systemName: "photo")
    let formatter = RelativeDateTimeFormatter()
    let outerPadding : CGFloat = 20
    
    @State var replyBoxOpen: Bool = false
    @State var isEditable = false
    @State var replyContent = NSTextStorage(string: "")
    @State var test = NSTextStorage(string: "")
    @State var isReplyingToThread = true
    
    @ObservedObject var fancyPantsBarStateObject = FancyPantsBarStateObject()
    
    func endEditing() {
        UIApplication.shared.endEditing()
    }
    
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
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    ScrollView() {
                        VStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    VStack(spacing: 0) {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color.orange)
                                    }
                                    .frame(width: 30)
                                    .padding(.trailing, 5)
                                    
                                    VStack(alignment: .leading) {
                                        Text(self.gameDataStore.users[self.gameDataStore.threads[self.threadId]!.author]!.username)
                                            .frame(height: a.size.height * 0.025, alignment: .leading)
                                        Text(self.getRelativeDate(postedDate: self.gameDataStore.threads[self.threadId]!.created))
                                            .font(.system(size: 14))
                                            .frame(height: a.size.height * 0.020, alignment: .leading)
                                            .foregroundColor(Color(.darkGray))
                                    }
                                }
                                .frame(width: a.size.width - self.outerPadding * 2, height: a.size.height * 0.045, alignment: .leading)
                                .padding(.bottom, 20)
                                
                                FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: self.$isEditable, isNewContent: false, isThread: true, threadId: self.threadId, isFirstResponder: false, fancyPantsBarStateObject: self.fancyPantsBarStateObject)
                                    .frame(width: a.size.width - self.outerPadding * 2, height: self.gameDataStore.threadsDesiredHeight[self.threadId]! + (self.isEditable ? 20 : 0))
                                    .padding(.bottom, 20)
                                
                                if (self.gameDataStore.threadsImages[self.threadId] != nil) {
                                    HStack(spacing: 10) {
                                        ForEach(self.gameDataStore.threadsImages[self.threadId]!, id: \.self) { image in
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(5)
                                                .frame(minWidth: a.size.width * 0.05, maxWidth: a.size.width * 0.25, minHeight: a.size.height * 0.1, maxHeight: a.size.height * 0.15, alignment: .center)
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
                                .frame(width: a.size.width - self.outerPadding * 2, height: a.size.height * 0.05)
                                
                                if !self.gameDataStore.mainCommentListByThreadId[self.threadId]!.isEmpty {
                                    VStack(spacing: 0) {
                                        ForEach(self.gameDataStore.mainCommentListByThreadId[self.threadId]!, id: \.self) { commentId in
                                            CommentView(commentId: commentId, width: a.size.width - self.outerPadding * 2, height: a.size.height, leadPadding: 0, level: 0)
                                        }
                                    }
                                    .padding(.top, 20)
                                }
                            }
                        }
                        .padding(.all, self.outerPadding)
                    }
                    
                    if self.gameDataStore.moreCommentsByThreadId[self.threadId] != nil && self.gameDataStore.moreCommentsByThreadId[self.threadId]!.count > 0 {
                        Button(action: self.fetchNextPage) {
                            Text("More comments ->")
                        }
                        .frame(width: a.size.width - self.outerPadding * 2, height: a.size.height * 0.05, alignment: .leading)
                        .padding(.all, self.outerPadding)
                    }
                }
                .frame(width: a.size.width)
                
                VStack(spacing: 0) {
                    FancyPantsEditorView(newTextStorage: self.$replyContent, isEditable: .constant(true), isNewContent: true, isThread: false, isFirstResponder: false, fancyPantsBarStateObject: self.fancyPantsBarStateObject)
                        .frame(width: a.size.width * 0.5, height: a.size.height * 0.1 * 0.8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .stroke(lineWidth: 1)
                    )
                    .background(self.gameDataStore.keyboardHeight == 0 ? Color.white : Color.red)
                }
                .frame(width: a.size.width, height: a.size.height * 0.1, alignment: .leading)
            }
            .onTapGesture {
                self.endEditing()
            }
            .KeyboardAwarePadding()
        }
        .onAppear() {
            self.gameDataStore.fetchCommentTreeByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId, refresh: true)
            self.gameDataStore.loadThreadIcons(thread: self.gameDataStore.threads[self.threadId]!)
            
        }
        .navigationBarTitle(Text(self.gameDataStore.threads[threadId]!.title))
    }
    
}
