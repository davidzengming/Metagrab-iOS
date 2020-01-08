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
    
    func transformVotesString() -> String {
        let isNegative = self.gameDataStore.threads[threadId]!.downvotes > self.gameDataStore.threads[threadId]!.upvotes
        let numPoints = abs(self.gameDataStore.threads[threadId]!.upvotes - self.gameDataStore.threads[threadId]!.downvotes)
        
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
//    func fetchNextPageIfBottom() {
//        print("fetching", threadId)
//        if self.gameDataStore.forumsNextPageStartIndex[gameId] == -1 || self.gameDataStore.threadListByGameId[gameId]?.last! != threadId || self.gameDataStore.isGameFetchingThreads[gameId] == true {
//            print(self.gameDataStore.forumsNextPageStartIndex[gameId] == -1, self.gameDataStore.threadListByGameId[gameId]?.last! != threadId, self.gameDataStore.isGameFetchingThreads[gameId] == true)
//            return
//        }
//
//        self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[gameId]!, start: self.gameDataStore.forumsNextPageStartIndex[gameId]!)
//    }
    
    var body: some View {
        VStack {
            Text(getRelativeDate(postedDate: self.gameDataStore.threads[threadId]!.created))
            Text(self.gameDataStore.users[self.gameDataStore.threads[threadId]!.author]!.username)
            
            NavigationLink(destination: ThreadView(threadId: threadId)) {
                HStack {
                    Text(self.gameDataStore.threads[threadId]!.title)
                        .font(.system(size: 22))
                    Spacer()
                }
            }.buttonStyle(PlainButtonStyle())

            if (self.gameDataStore.threadsImage[threadId] != nil) {
                Image(uiImage: self.gameDataStore.threadsImage[threadId]!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: 260)
                    .cornerRadius(5)
                    .padding(5)
            } else {
                Text(self.gameDataStore.threads[threadId]!.content)
                .font(.system(size: 15))
                .lineLimit(5)
                .padding(15)
            }
            
            Divider()
            
            HStack {
                Text("💬 " + (self.gameDataStore.threads[threadId]!.numSubtreeNodes != 0 ? String(self.gameDataStore.threads[threadId]!.numSubtreeNodes) : "") + " Comments")
                .font(.system(size: 12))
                Spacer()
                
                HStack {
                    Button(action: onClickUpvoteButton) {
                        Text("👍")
                    }
                    Spacer()
                    Text(self.transformVotesString())
                        .foregroundColor(self.gameDataStore.voteThreadMapping[threadId] != nil && self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.direction != 0 ? Color.red : Color.green)
                    .font(.system(size: 12))
                    Spacer()
                    Button(action: onClickDownvoteButton) {
                        Text("👎")
                    }
                }
                .frame(width: 100)
            }
        }
        .padding(15)
            
        .onAppear() {
                self.gameDataStore.loadThreadIcon(thread: self.gameDataStore.threads[self.threadId]!)
            }
        .background(Color.white)
    }
}


