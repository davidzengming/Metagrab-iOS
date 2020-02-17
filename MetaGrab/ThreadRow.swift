//
//  ThreadRow.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

import SwiftUI

struct ThreadRow : View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var threadId: Int
    var gameId: Int
    let placeholder = Image(systemName: "photo")
    let formatter = RelativeDateTimeFormatter()
    
    let threadsFromBottomToGetReadyToLoadNextPage = 1
    let threadsPerNewPageCount = 10
    
    func fetchNextPage() {
        DispatchQueue.main.async {
            if self.gameDataStore.forumsNextPageStartIndex[self.gameId] == nil || self.gameDataStore.forumsNextPageStartIndex[self.gameId]! == -1 || self.gameDataStore.isLoadingNextPageInForum[self.gameId] == nil || self.gameDataStore.isLoadingNextPageInForum[self.gameId]! == true || self.gameDataStore.threadsIndexInGameList[self.threadId] == nil || self.gameDataStore.threadsIndexInGameList[self.threadId]! < self.gameDataStore.threadListByGameId[self.gameId]!.count - self.threadsFromBottomToGetReadyToLoadNextPage {
                return
            }
            
            self.gameDataStore.isLoadingNextPageInForum[self.gameId] = true

            self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[self.gameId]!, start: self.gameDataStore.forumsNextPageStartIndex[self.gameId]!)
        }
    }
    
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
    
    func transformVotesString(points: Int) -> String {
        let isNegative = false
        let numPoints = points
        
        var concatVotesStr = ""
        if numPoints > 1000000 {
            concatVotesStr = String((Double(numPoints) / 1000000 * 10).rounded() / 10)
            concatVotesStr += " M"
        } else if numPoints > 1000 {
            concatVotesStr = String((Double(numPoints) / 1000 * 10).rounded() / 10)
            concatVotesStr += " K"
        } else {
            concatVotesStr += String(numPoints)
        }
        
        return ((isNegative ? "-" : "" ) + concatVotesStr)
    }
    
    func getRelativeDate(postedDate: Date) -> String {
        return formatter.localizedString(for: postedDate, relativeTo: Date())
    }
    
    func isVotedUp() -> Bool {
        return self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == 1
    }
    
    func isVotedDown() -> Bool {
        return self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction == -1
    }
    
    var body: some View {
        VStack {
            Text(self.getRelativeDate(postedDate: self.gameDataStore.threads[self.threadId]!.created))
                .frame(width: 100, height: 20, alignment: .center)
            Text(self.gameDataStore.users[self.gameDataStore.threads[self.threadId]!.author]!.username)
                .frame(width: 100, height: 20, alignment: .center)
            
            NavigationLink(destination: ThreadView(threadId: self.threadId)) {
                VStack {
                    HStack {
                        if self.gameDataStore.threads[self.threadId]!.title.count > 0 {
                            Text(self.gameDataStore.threads[self.threadId]!.title)
                                .font(.system(size: 18))
                            Spacer()
                        }
                    }
                    if self.gameDataStore.threadsTextStorage[self.threadId] != nil {
                        FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: .constant(false), isNewContent: false, isThread: true, threadId: self.threadId, isFirstResponder: false)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .background(Color.red)
            
            
            if (self.gameDataStore.threadsImage[self.threadId] != nil) {
                HStack {
                    Image(uiImage: self.gameDataStore.threadsImage[self.threadId]!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 50, maxWidth: 100, minHeight: 100, maxHeight: 150)
                        .cornerRadius(5)
                        .padding(5)
                    Spacer()
                }
            }
            
            HStack {
                HStack {
                    Image(uiImage: UIImage(systemName: "bubble.left")!)
                    Text(String(self.gameDataStore.threads[self.threadId]!.numSubtreeNodes))
                    .font(.system(size: 12))
                }
                .frame(width: 60, height: 30, alignment: .center)
                
                HStack {
                    Image(uiImage: UIImage(systemName: self.isVotedUp() ? "hand.thumbsup.fill" : "hand.thumbsup")!)
                        .onTapGesture {
                            self.onClickUpvoteButton()
                        }
                    Text(self.transformVotesString(points: self.gameDataStore.threads[self.threadId]!.upvotes))
                    .font(.system(size: 12))
                }
                .frame(width: 60, height: 30, alignment: .center)

                HStack {
                    Image(uiImage: UIImage(systemName: self.isVotedDown() ? "hand.thumbsdown.fill" : "hand.thumbsdown")!)
                        .onTapGesture {
                            self.onClickDownvoteButton()
                        }
                    Text(self.transformVotesString(points: self.gameDataStore.threads[self.threadId]!.downvotes))
                    .font(.system(size: 12))
                }
                .frame(width: 60, height: 30, alignment: .center)
                
                Spacer()
            }
            .padding(.top, 10)
        }
        .padding(.vertical, 5)
        .onAppear() {
            self.gameDataStore.loadThreadIcon(thread: self.gameDataStore.threads[self.threadId]!)
            self.fetchNextPage()
            print(self.gameDataStore.threadsDesiredHeight[self.threadId]!, self.threadId, "test id")
        }
        .background(Color.white)
        
    }
}


