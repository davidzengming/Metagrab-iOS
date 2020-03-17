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
    var width: CGFloat
    var height: CGFloat
    
    let placeholder = Image(systemName: "photo")
    let formatter = RelativeDateTimeFormatter()
    
    let threadsFromBottomToGetReadyToLoadNextPage = 1
    let threadsPerNewPageCount = 10
    
    @ObservedObject var fancyPantsBarStateObject = FancyPantsBarStateObject()
    
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
                    
                    Text(self.getRelativeDate(postedDate: self.gameDataStore.threads[self.threadId]!.created))
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
                        FancyPantsEditorView(newTextStorage: .constant(NSTextStorage(string: "")), isEditable: .constant(false), isNewContent: false, isThread: true, threadId: self.threadId, isFirstResponder: false, fancyPantsBarStateObject: self.fancyPantsBarStateObject)
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
                
                HStack {
                    Image(uiImage: UIImage(systemName: self.isVotedUp() ? "hand.thumbsup.fill" : "hand.thumbsup")!)
                        .onTapGesture {
                            self.onClickUpvoteButton()
                    }
                    Text(self.transformVotesString(points: self.gameDataStore.threads[self.threadId]!.upvotes))
                        .font(.system(size: 16))
                }
                .frame(width: self.width * 0.15, height: self.height * 0.025, alignment: .leading)
                
                HStack {
                    Image(uiImage: UIImage(systemName: self.isVotedDown() ? "hand.thumbsdown.fill" : "hand.thumbsdown")!)
                        .onTapGesture {
                            self.onClickDownvoteButton()
                    }
                }
                .frame(width: self.width * 0.15, height: self.height * 0.025, alignment: .leading)
                
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


