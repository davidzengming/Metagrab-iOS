//
//  UserProfileView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-05-11.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    @State var loadedBlacklist = false
    @State var loadedHiddenThreads = false
    @State var loadedHiddenComments = false
    
    func unblockUser(unblockUserId: Int) {
        self.gameDataStore.unblockUser(access: self.userDataStore.token!.access, userId: self.userDataStore.token!.userId, targetUnblockUserId: unblockUserId)
    }
    
    func unhideThread(threadId: Int) {
        self.gameDataStore.unhideThread(access: self.userDataStore.token!.access, threadId: threadId)
    }
    
    func unhideComment(commentId: Int) {
        self.gameDataStore.unhideComment(access: self.userDataStore.token!.access, commentId: commentId)
    }
    
    func fetchBlacklistedUsers() {
        self.gameDataStore.fetchBlacklistedUsers(access: self.userDataStore.token!.access, userId: self.userDataStore.token!.userId)
        self.loadedBlacklist = true
    }
    
    func fetchHiddenThreads() {
        self.gameDataStore.fetchHiddenThreads(access: self.userDataStore.token!.access, userId: self.userDataStore.token!.userId)
        self.loadedHiddenThreads = true
    }
    
    func fetchHiddenComments() {
        self.gameDataStore.fetchHiddenComments(access: self.userDataStore.token!.access, userId: self.userDataStore.token!.userId)
        self.loadedHiddenComments = true
    }
    
    var body: some View {
        ZStack {
            self.gameDataStore.colors["darkButNotBlack"].edgesIgnoringSafeArea(.all)
            
            GeometryReader { a in
                VStack {
                    HStack(alignment: .top) {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 0) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color.orange)
                        }
                        
                        VStack(alignment: .trailing, spacing: 0) {
                            Text(self.userDataStore.username!)
                        }
                    }
                    .padding()
                    
                    VStack {
                        Text("Blacklist")
                        
                        if self.loadedBlacklist == false {
                            Button(action: self.fetchBlacklistedUsers) {
                                Text("Load blacklisted users")
                                .padding(7)
                                    .background(Color.red)
                                    .foregroundColor(Color.white)
                                .cornerRadius(10)
                            }
                            .padding(.top, 10)
                        }

                        
                        ForEach(self.gameDataStore.blacklistedUserIdArr, id: \.self) { blacklistedUserId in
                            HStack {
                                Text(self.gameDataStore.blacklistedUsersById[blacklistedUserId]!.username)
                                HStack(alignment: .center) {
                                    Image(systemName: "multiply")
                                    .resizable()
                                    .frame(width: a.size.height * 0.05, height: a.size.height * 0.05)
                                        .foregroundColor(.white)
                                        .onTapGesture {
                                            self.unblockUser(unblockUserId: blacklistedUserId)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    VStack {
                        Text("Hidden Threads")
                        
                        if self.loadedHiddenThreads == false {
                            Button(action: self.fetchHiddenThreads) {
                                Text("Load hidden threads")
                                .padding(7)
                                    .background(Color.red)
                                    .foregroundColor(Color.white)
                                .cornerRadius(10)
                            }
                            .padding(.top, 10)
                        }

                        
                        ForEach(self.gameDataStore.hiddenThreadIdArr, id: \.self) { hiddenThreadId in
                            HStack {
                                Text(self.gameDataStore.hiddenThreadsById[hiddenThreadId]!.title)
                                Image(systemName: "multiply")
                                .resizable()
                                .frame(width: a.size.height * 0.05, height: a.size.height * 0.05)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        self.unhideThread(threadId: hiddenThreadId)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    VStack {
                        Text("Hidden Comments")
                        
                        if self.loadedHiddenComments == false {
                            Button(action: self.fetchHiddenComments) {
                                Text("Load hidden comments")
                                .padding(7)
                                    .background(Color.red)
                                    .foregroundColor(Color.white)
                                .cornerRadius(10)
                            }
                            .padding(.top, 10)
                        }
                                                
                        ForEach(self.gameDataStore.hiddenCommentIdArr, id: \.self) { hiddenCommentId in
                            HStack {
                                Text(self.gameDataStore.hiddenCommentsById[hiddenCommentId]!.contentString)
                                Image(systemName: "multiply")
                                .resizable()
                                .frame(width: a.size.height * 0.05, height: a.size.height * 0.05)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        self.unhideComment(commentId: hiddenCommentId)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
                .frame(width: a.size.width, height: a.size.height)
                .foregroundColor(Color.white)
            }
        }
    }
}
