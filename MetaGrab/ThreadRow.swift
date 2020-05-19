//
//  ThreadRow.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct ThreadRow : View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var threadId: Int
    var gameId: Int
    var width: CGFloat
    var height: CGFloat
    
    let placeholder = Image(systemName: "photo")
    let formatter = RelativeDateTimeFormatter()
    
    let threadsFromBottomToGetReadyToLoadNextPage = 1
    let threadsPerNewPageCount = 10
    
    @State var smileyFaceCounter = 0
    @State var upvoteCounter = 0
    @State var downvoteCounter = 0
    @State var showEmojiModal = false
    
    //    func fetchNextPage() {
    //        DispatchQueue.main.async {
    //            if self.gameDataStore.forumsNextPageStartIndex[self.gameId] == nil || self.gameDataStore.forumsNextPageStartIndex[self.gameId]! == -1 || self.gameDataStore.isLoadingNextPageInForum[self.gameId] == nil || self.gameDataStore.isLoadingNextPageInForum[self.gameId]! == true || self.gameDataStore.threadsIndexInGameList[self.threadId] == nil || self.gameDataStore.threadsIndexInGameList[self.threadId]! < self.gameDataStore.threadListByGameId[self.gameId]!.count - self.threadsFromBottomToGetReadyToLoadNextPage {
    //                return
    //            }
    //
    //            self.gameDataStore.isLoadingNextPageInForum[self.gameId] = true
    //            self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[self.gameId]!, start: self.gameDataStore.forumsNextPageStartIndex[self.gameId]!)
    //        }
    //    }
    
    func onClickUpvoteButton() {
        if self.gameDataStore.voteThreadMapping[threadId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 1 {
                self.gameDataStore.deleteThreadVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!, userId: self.userDataStore.token!.userId)
            } else if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 0 {
                self.gameDataStore.upvoteByExistingVoteIdThread(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteThreadMapping[threadId]!, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
            } else {
                self.gameDataStore.switchUpvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
            }
        } else {
            self.gameDataStore.addNewUpvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
        }
    }
    
    func onClickDownvoteButton() {
        if self.gameDataStore.voteThreadMapping[threadId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == -1 {
                self.gameDataStore.deleteThreadVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!, userId: self.userDataStore.token!.userId)
            } else if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 0 {
                self.gameDataStore.downvoteByExistingVoteIdThread(access: self.userDataStore.token!.access, voteId: self.gameDataStore.voteThreadMapping[threadId]!, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
            } else {
                self.gameDataStore.switchDownvoteThread(access:  self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
            }
        } else {
            self.gameDataStore.addNewDownvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!, userId: self.userDataStore.token!.userId)
        }
    }
    
    func isVotedUp() -> Bool {
        return self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 1
    }
    
    func isVotedDown() -> Bool {
        return self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == -1
    }
    
    func onClickAddEmojiBubble() {
        self.gameDataStore.addEmojiThreadIdByForumId[self.gameDataStore.threads[self.threadId]!.forum] = self.threadId
        self.gameDataStore.isAddEmojiModalActiveByForumId[self.gameDataStore.threads[self.threadId]!.forum] = true
    }
    
    func onClickUser() {
        if self.gameDataStore.users[self.gameDataStore.threads[self.threadId]!.author]!.id == self.userDataStore.token!.userId {
            return
        }
        
        self.gameDataStore.isAddEmojiModalActiveByForumId[self.gameDataStore.threads[self.threadId]!.forum] = false
        self.gameDataStore.isReportPopupActiveByForumId[self.gameId] = false
        
        self.gameDataStore.lastClickedBlockUserByForumId[self.gameId] = self.gameDataStore.users[self.gameDataStore.threads[self.threadId]!.author]!.id
        self.gameDataStore.isBlockPopupActiveByForumId[self.gameId] = true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(spacing: 0) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.orange)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(self.gameDataStore.users[self.gameDataStore.threads[self.threadId]!.author]!.username)
                        .frame(height: self.height * 0.025, alignment: .leading)
                        .onTapGesture {
                            self.onClickUser()
                    }
                    
                    Text(self.gameDataStore.relativeDateStringByThreadId[self.threadId]!)
                        .font(.system(size: 14))
                        .frame(height: self.height * 0.02, alignment: .leading)
                        .foregroundColor(Color(.darkGray))
                }
                
                Spacer()
            }
            .frame(width: self.width, height: self.height * 0.045, alignment: .leading)
            .padding(.bottom, 10)
            
            NavigationLink(destination: ThreadView(threadId: self.threadId, gameId: self.gameId)) {
                VStack(alignment: .leading) {
                    HStack {
                        if self.gameDataStore.threads[self.threadId]!.title.count > 0 {
                            Text(self.gameDataStore.threads[self.threadId]!.title)
                                .fontWeight(.medium)
                            Spacer()
                        }
                    }
                    
                    if self.gameDataStore.threadsTextStorage[self.threadId] != nil {
                        FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: .constant(false), isFirstResponder: .constant(false), didBecomeFirstResponder: .constant(false), showFancyPantsEditorBar: .constant(false), isNewContent: false, isThread: true, threadId: self.threadId, isOmniBar: false)
                            .frame(width: self.width * 0.9, height: min(self.gameDataStore.threadsDesiredHeight[self.threadId]!, 200), alignment: .leading)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 10)
            
            if self.gameDataStore.threadsImages[self.threadId] != nil && self.gameDataStore.threadsImages[self.threadId]!.count != 0 {
                HStack(spacing: 10) {
                    ForEach(self.gameDataStore.threadsImages[self.threadId]!, id: \.self) { uiImage in
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(5)
                            .frame(minWidth: self.width * 0.05, maxWidth: self.width * 0.25, minHeight: self.height * 0.1, maxHeight: self.height * 0.15, alignment: .center)
                    }
                }
                .padding(.vertical, 10)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    
                    HStack(spacing: 5) {
                        Image(systemName: "bubble.right.fill")
                        Text(String(self.gameDataStore.threads[self.threadId]!.numSubtreeNodes))
                            .font(.system(size: 16))
                            .bold()
                        Text("Comments")
                            .bold()
                    }
                    .frame(height: self.height * 0.025, alignment: .leading)
                    
                    HStack {
                        if self.gameDataStore.isThreadHiddenByThreadId[self.threadId]! == true {
                            Text("Unhide")
                                .bold()
                                .onTapGesture {
                                    self.gameDataStore.unhideThread(access: self.userDataStore.token!.access, threadId: self.threadId)
                            }
                        } else {
                            Text("Hide")
                                .bold()
                                .onTapGesture {
                                    self.gameDataStore.hideThread(access: self.userDataStore.token!.access, threadId: self.threadId)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Report")
                            .bold()
                            .onTapGesture {
                                self.gameDataStore.isBlockPopupActiveByForumId[self.gameId] = false
                                self.gameDataStore.isAddEmojiModalActiveByForumId[self.gameDataStore.threads[self.threadId]!.forum] = false
                                self.gameDataStore.lastClickedReportThreadByForumId[self.gameId] = self.threadId
                                self.gameDataStore.isReportPopupActiveByForumId[self.gameId] = true
                        }
                    }
                    
                    Spacer()
                }
                .foregroundColor(Color.gray)
                .frame(width: self.width * 0.9)
                
                EmojiBarThreadView(threadId: threadId, isInThreadView: false)
            }
            .padding(.top, 10)
        }
        .padding(.all, 20)
        .frame(width: self.width)
        .onAppear() {
            self.gameDataStore.loadThreadIcons(thread: self.gameDataStore.threads[self.threadId]!)
        }
        .background(Color.white)
    }
}


