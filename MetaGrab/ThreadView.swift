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
    @State var showFancyPantsEditorBar = false
    @State var replyContent = NSTextStorage(string: "")
    @State var test = NSTextStorage(string: "")
    @State var isFirstResponder = false
    @State var didBecomeFirstResponder = false
    
    func onClickUpvoteButton() {
        if self.gameDataStore.voteThreadMapping[threadId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 1 {
                self.gameDataStore.deleteThreadVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!)
            } else if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 0 {
                self.gameDataStore.upvoteByExistingVoteIdThread(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteThreadMapping[threadId]!, thread: self.gameDataStore.threads[threadId]!)
            } else {
                self.gameDataStore.switchUpvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!)
            }
        } else {
            self.gameDataStore.addNewUpvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!)
        }
    }
    
    func onClickDownvoteButton() {
        if self.gameDataStore.voteThreadMapping[threadId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == -1 {
                self.gameDataStore.deleteThreadVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!)
            } else if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 0 {
                self.gameDataStore.downvoteByExistingVoteIdThread(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteThreadMapping[threadId]!, thread: self.gameDataStore.threads[threadId]!)
            } else {
                self.gameDataStore.switchDownvoteThread(access:  self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!)
            }
        } else {
            self.gameDataStore.addNewDownvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!)
        }
    }
    
    func scrollToOriginalThread() {
        
    }
    
    func shareToSocialMedia() {
        
    }
    
    
    func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    func postPrimaryComment() {
        self.gameDataStore.postMainComment(access: self.userDataStore.token!.access, threadId: threadId, content: replyContent)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchCommentTreeByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId, start: self.gameDataStore.threadsNextPageStartIndex[threadId]!, userId: self.userDataStore.token!.userId)
    }
    
    func toggleEditMode() {
        self.isEditable = !self.isEditable
    }
    
    func toggleReplyBarActive() {
        self.didBecomeFirstResponder = true
    }
    
    func setReplyTargetToThread() {
        self.gameDataStore.isReplyBarReplyingToThreadByThreadId[threadId] = true
        self.gameDataStore.replyTargetCommentIdByThreadId[threadId] = -1

        self.toggleReplyBarActive()
    }
    
    func submit() {
        if self.gameDataStore.isReplyBarReplyingToThreadByThreadId[threadId]  == true {
            self.gameDataStore.postMainComment(access: self.userDataStore.token!.access, threadId: threadId, content: replyContent)
        } else {
            self.gameDataStore.postChildComment(access: self.userDataStore.token!.access, parentCommentId: self.gameDataStore.replyTargetCommentIdByThreadId[threadId]!, content: replyContent)
        }
        
        self.replyContent.replaceCharacters(in: NSMakeRange(0, replyContent.mutableString.length), with: "")
        self.gameDataStore.threadViewReplyBarDesiredHeight[self.threadId] = 20
        self.endEditing()
    }
    
    var body: some View {
        ZStack {
            Color(red: 248 / 255, green: 248 / 255, blue: 248 / 255)
                .edgesIgnoringSafeArea(.all)
            GeometryReader { a in
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        ScrollView() {
                            VStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 0) {
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
                                                Text(self.gameDataStore.users[self.gameDataStore.threads[self.threadId]!.author]!.username)
                                                    .font(.system(size: 16))
                                                Spacer()
                                            }
                                            Text(self.gameDataStore.relativeDateStringByThreadId[self.threadId]!)
                                                .foregroundColor(Color(.darkGray))
                                                .font(.system(size: 14))
                                                .padding(.bottom, 5)
                                        }
                                    }
                                    .padding(.bottom, 20)
                                    
                                    FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: self.$isEditable, isFirstResponder: .constant(false), didBecomeFirstResponder: .constant(false), showFancyPantsEditorBar: .constant(false), isNewContent: false, isThread: true, threadId: self.threadId, isOmniBar: false)
                                        .frame(width: a.size.width - self.outerPadding * 2, height: self.gameDataStore.threadsDesiredHeight[self.threadId]! + (self.isEditable ? 20 : 0))
                                        .padding(.bottom, 20)
                                        .onTapGesture {
                                            self.setReplyTargetToThread()
                                    }
                                    
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
                                    
                                    HStack(spacing: 0) {
                                        Spacer()
                                        VStack {
                                            Button(action: self.shareToSocialMedia) {
                                                VStack {
                                                    Image(systemName: "arrowshape.turn.up.right.fill")
                                                    .resizable()
                                                    Text("Share")
                                                }
                                                
                                            }
                                        }
                                        .frame(width: ceil((a.size.width - self.outerPadding * 2) / 8), height: ceil((a.size.width - self.outerPadding * 2) / 8) + 20)
                                        
                                        Spacer()
                                        VStack(alignment: .center) {
                                            Button(action: self.scrollToOriginalThread) {
                                                VStack {
                                                    Image(systemName: "quote.bubble.fill")
                                                    .resizable()
                                                    Text(String(self.gameDataStore.threads[self.threadId]!.numChilds))
                                                }
                                            }
                                        }
                                        .frame(width: ceil((a.size.width - self.outerPadding * 2) / 8), height: ceil((a.size.width - self.outerPadding * 2) / 8) + 20)
                                        
                                        Spacer()
                                        VStack(alignment: .center) {
                                            Button(action: self.onClickUpvoteButton) {
                                                VStack {
                                                    Image(systemName: "hand.thumbsup.fill")
                                                    .resizable()
                                                    Text(self.gameDataStore.threadsVoteStringByThreadId[self.threadId]!)
                                                }
                                            }
                                        }
                                        .frame(width: ceil((a.size.width - self.outerPadding * 2) / 8), height: ceil((a.size.width - self.outerPadding * 2) / 8) + 20)
                                        
                                        Spacer()
                                        VStack(alignment: .center) {
                                            Button(action: self.onClickDownvoteButton) {
                                                VStack {
                                                    Image(systemName: "hand.thumbsdown.fill")
                                                    .resizable()
                                                    Text(self.gameDataStore.threadsDownvoteStringByThreadId[self.threadId]!)
                                                }
                                            }
                                        }
                                        .frame(width: ceil((a.size.width - self.outerPadding * 2) / 8), height: ceil((a.size.width - self.outerPadding * 2) / 8) + 20)
                                        
                                        Spacer()
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .frame(width: a.size.width - self.outerPadding * 2, height: ceil((a.size.width - self.outerPadding * 2) / 8) + 20)
                                    .padding(.vertical, 35)
                                    
                                    if !self.gameDataStore.mainCommentListByThreadId[self.threadId]!.isEmpty {
                                        VStack(spacing: 0) {
                                            ForEach(self.gameDataStore.mainCommentListByThreadId[self.threadId]!, id: \.self) { commentId in
                                                CommentView(ancestorThreadId: self.threadId, commentId: commentId, width: a.size.width - self.outerPadding * 2, height: a.size.height, leadPadding: 0, level: 0)
                                            }
                                        }
                                    }
                                    
                                    if self.gameDataStore.moreCommentsByThreadId[self.threadId] != nil && self.gameDataStore.moreCommentsByThreadId[self.threadId]!.count > 0 {
                                        Button(action: self.fetchNextPage) {
                                            Text("Load more comments (\(self.gameDataStore.threads[self.threadId]!.numChilds - self.gameDataStore.mainCommentListByThreadId[self.threadId]!.count) replies)")
                                        }
                                        .frame(width: a.size.width - self.outerPadding * 2, height: a.size.height * 0.05, alignment: .leading)
                                        .padding(.vertical, 10)
                                    }
                                }
                            }
                            .padding(.all, self.outerPadding)
                        }
                    }
                    .frame(width: a.size.width)
                    .onTapGesture {
                        self.endEditing()
                        self.didBecomeFirstResponder = false
                        self.isFirstResponder = false
                    }
                    
                    VStack(spacing: 0) {
                        FancyPantsEditorView(newTextStorage: self.$replyContent, isEditable: .constant(true), isFirstResponder: self.$isFirstResponder, didBecomeFirstResponder: self.$didBecomeFirstResponder, showFancyPantsEditorBar: self.$showFancyPantsEditorBar, isNewContent: true, isThread: true, threadId: self.threadId, isOmniBar: true, submit: { self.submit() })
                    }
                    .frame(width: a.size.width, height: self.gameDataStore.keyboardHeight == 0 ? 50 : (self.gameDataStore.threadViewReplyBarDesiredHeight[self.threadId]! + 20 + 20 + 40))
                    .background(Color.white)
                }
                .KeyboardAwarePadding()

            }
            .onAppear() {
                self.gameDataStore.fetchCommentTreeByThreadId(access: self.userDataStore.token!.access, threadId: self.threadId, refresh: true, userId: self.userDataStore.token!.userId)
                self.gameDataStore.loadThreadIcons(thread: self.gameDataStore.threads[self.threadId]!)
            }
            .navigationBarTitle(Text(self.gameDataStore.threads[threadId]!.title))
        }
    }
}
