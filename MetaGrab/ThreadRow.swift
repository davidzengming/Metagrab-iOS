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
    
    func onClickUpvoteButton() {
        if self.gameDataStore.voteThreadMapping[threadId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.isPositive == true {
                            self.gameDataStore.deleteThreadVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!)
            } else {
                
                print("switch vote")
                self.gameDataStore.switchUpvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!)
            }
        } else {
            self.gameDataStore.upvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!)
        }
    }
    
    func onClickDownvoteButton() {
        if self.gameDataStore.voteThreadMapping[threadId] != nil {
            if self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!.isPositive == false {
                print("delete negative vote")
                self.gameDataStore.deleteThreadVote(access: self.userDataStore.token!.access, vote: self.gameDataStore.votes[self.gameDataStore.voteThreadMapping[threadId]!]!)
            } else {
                self.gameDataStore.switchDownvoteThread(access:  self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!)
            }
        } else {
            self.gameDataStore.downvoteThread(access: self.userDataStore.token!.access, thread: self.gameDataStore.threads[threadId]!)
        }
    }
    
    var body: some View {
        HStack {
            VStack {
                if self.gameDataStore.voteThreadMapping[threadId] != nil {
                    Text("Hi I voted on this")
                }
                Button(action: onClickUpvoteButton) {
                    Text("👍")
                }
                Spacer()
                Text(String(self.gameDataStore.threads[threadId]!.upvotes - self.gameDataStore.threads[threadId]!.downvotes))
                Spacer()
                Button(action: onClickDownvoteButton) {
                    Text("👎")
                }
            }
            NavigationLink(destination: ThreadView(threadId: threadId)) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(self.gameDataStore.threads[threadId]!.title)
                            .font(.title)
                        Text(String(self.gameDataStore.threads[threadId]!.numSubtreeNodes) + " Comments")
                            .font(.caption)
                    }
                    Spacer()
                    Text("➤")
                }
            }.buttonStyle(PlainButtonStyle())
        }
    }
}
