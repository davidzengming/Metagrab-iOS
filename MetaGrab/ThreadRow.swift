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
    
    func isVotedUp() -> Bool {
        return self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 1
    }
    
    func isVotedDown() -> Bool {
        return self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == -1
    }
    
    func addOrRemoveEmoji(emojiId: Int) {
        self.gameDataStore.addEmojiByThreadId(access: self.userDataStore.token!.access, threadId: threadId, emojiId: emojiId, userId: self.userDataStore.token!.userId)
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
                    
                    Text(self.gameDataStore.relativeDateStringByThreadId[self.threadId]!)
                        .font(.system(size: 14))
                        .frame(height: self.height * 0.02, alignment: .leading)
                        .foregroundColor(Color(.darkGray))
                }
            }
            .frame(width: self.width, height: self.height * 0.045, alignment: .leading)
            .padding(.bottom, 10)
            
            NavigationLink(destination: ThreadView(threadId: self.threadId)) {
                VStack(alignment: .leading) {
                    HStack {
                        if self.gameDataStore.threads[self.threadId]!.title.count > 0 {
                            Text(self.gameDataStore.threads[self.threadId]!.title)
                                .fontWeight(.medium)
                                .font(.system(size: 16))
                            Spacer()
                        }
                    }
                    if self.gameDataStore.threadsTextStorage[self.threadId] != nil {
                        FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: .constant(false), isFirstResponder: .constant(false), didBecomeFirstResponder: .constant(false), showFancyPantsEditorBar: .constant(false), isNewContent: false, isThread: true, threadId: self.threadId, isOmniBar: false)
                            .frame(width: self.width * 0.9, height: min(self.gameDataStore.threadsDesiredHeight[threadId]!, 200), alignment: .leading)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            
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
                .padding(.vertical, 20)
            }
            
            HStack(spacing: 20) {
                HStack {
                    Image(uiImage: UIImage(systemName: "bubble.left")!)
                    Text(String(self.gameDataStore.threads[self.threadId]!.numSubtreeNodes))
                        .font(.system(size: 16))
                }
                .frame(width: self.width * 0.15, height: self.height * 0.025, alignment: .leading)
                
                HStack(spacing: 5) {
                    ForEach(self.gameDataStore.emojiArrByThreadId[threadId]!, id: \.self) { emojiId in
                        HStack {
                            Image(uiImage: self.gameDataStore.emojis[emojiId]!)
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(String(self.gameDataStore.emojiCountByThreadId[self.threadId]![emojiId]!))
                        }
                        .frame(width: 40, height: 20)
                        .background(self.gameDataStore.didReactToEmojiByThreadId[self.threadId]![emojiId]! == true ? Color.gray : Color.white)
                    }
                }
                
                HStack {
                    Button(action: {
                        self.addOrRemoveEmoji(emojiId: 0)
                    }) {
                        Text("Add to emoji 1")
                    }.buttonStyle(PlainButtonStyle())
                    .background(Color(red: 238 / 255, green: 238 / 255, blue: 238 / 255))
                    .cornerRadius(5)
                    
                    Button(action: {
                        self.showEmojiModal.toggle()
                    }) {
                        Image(systemName: "plus.bubble.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        .padding(.all, 5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showEmojiModal) {
                        EmojiModalView(showModal: self.$showEmojiModal)
                            .environmentObject(self.gameDataStore)
                    }
                    .background(Color(red: 238 / 255, green: 238 / 255, blue: 238 / 255))
                    .cornerRadius(5)
                }
                .padding(.vertical, 2)
                .padding(.horizontal, 5)
                .frame(alignment: .leading)
                
                Spacer()
            }
            .padding(.top, 10)
        }
        .padding(.all, 20)
        .onAppear() {
            self.gameDataStore.loadThreadIcons(thread: self.gameDataStore.threads[self.threadId]!)
        }
        .background(Color.white)
    }
}


