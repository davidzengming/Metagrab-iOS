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
            self.gameDataStore.colors["darkButNotBlack"].ignoresSafeArea()
            
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
                    .foregroundColor(Color.white)
                    .padding()
                    
                    ScrollView {
                        VStack {
                            VStack {
                                Text("BLACKLISTED USERS")
                                    .tracking(1)
                                    .padding()
                                    .frame(width: a.size.width * 0.9, height: a.size.height * 0.05, alignment: .leading)
                                    .background(self.gameDataStore.colors["teal"])
                                
                                if self.loadedBlacklist == false {
                                    Button(action: self.fetchBlacklistedUsers) {
                                        Text("Show blacklisted users")
                                            .padding()
                                            .background(Color.red)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(10)
                                    }
                                    .padding()
                                } else if self.loadedBlacklist == true && self.gameDataStore.blacklistedUserIdArr.isEmpty {
                                    Text("There are no blacklisted users.")
                                    .padding()
                                }
                                
                                ForEach(self.gameDataStore.blacklistedUserIdArr, id: \.self) { blacklistedUserId in
                                    HStack {
                                        Text(self.gameDataStore.blacklistedUsersById[blacklistedUserId]!.username)
                                        HStack(alignment: .center) {
                                            Image(systemName: "multiply")
                                                .resizable()
                                                .frame(width: a.size.height * 0.025, height: a.size.height * 0.025)
                                                .foregroundColor(.red)
                                                .onTapGesture {
                                                    self.unblockUser(unblockUserId: blacklistedUserId)
                                            }
                                        }
                                        
                                    }
                                    .padding()
                                }
                            }
                            .frame(width: a.size.width * 0.9)
                            .background(self.gameDataStore.colors["notQuiteBlack"])
                            .padding()
                            
                            VStack {
                                Text("HIDDEN THREADS")
                                    .tracking(1)
                                    .padding()
                                    .frame(width: a.size.width * 0.9, height: a.size.height * 0.05, alignment: .leading)
                                    .background(self.gameDataStore.colors["teal"])
                                
                                if self.loadedHiddenThreads == false {
                                    Button(action: self.fetchHiddenThreads) {
                                        Text("Show hidden threads")
                                            .padding()
                                            .background(Color.red)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(10)
                                    }
                                    .padding()
                                    
                                } else if self.loadedHiddenThreads == true && self.gameDataStore.hiddenThreadIdArr.isEmpty {
                                    Text("There are no hidden threads.")
                                    .padding()
                                }
                                
                                ForEach(self.gameDataStore.hiddenThreadIdArr, id: \.self) { hiddenThreadId in
                                    HStack {
                                        Text(self.gameDataStore.hiddenThreadsById[hiddenThreadId]!.title)
                                        Image(systemName: "multiply")
                                            .resizable()
                                            .frame(width: a.size.height * 0.025, height: a.size.height * 0.025)
                                            .foregroundColor(.red)
                                            .onTapGesture {
                                                self.unhideThread(threadId: hiddenThreadId)
                                        }
                                    }.padding()
                                }
                            }
                            .frame(width: a.size.width * 0.9)
                            .background(self.gameDataStore.colors["notQuiteBlack"])
                            .padding()
                            
                            VStack {
                                Text("HIDDEN COMMENTS")
                                    .tracking(1)
                                    .padding()
                                    .frame(width: a.size.width * 0.9, height: a.size.height * 0.05, alignment: .leading)
                                    .background(self.gameDataStore.colors["teal"])
                                
                                if self.loadedHiddenComments == false {
                                    Button(action: self.fetchHiddenComments) {
                                        Text("Show hidden comments")
                                            .padding()
                                            .background(Color.red)
                                            .foregroundColor(Color.white)
                                            .cornerRadius(10)
                                    }
                                    .padding()
                                    
                                } else if self.loadedHiddenComments == true && self.gameDataStore.hiddenCommentIdArr.isEmpty {
                                    Text("There are no hidden comments.")
                                    .padding()
                                }
                                
                                ForEach(self.gameDataStore.hiddenCommentIdArr, id: \.self) { hiddenCommentId in
                                    HStack {
                                        Text(self.gameDataStore.hiddenCommentsById[hiddenCommentId]!.contentString)
                                        Image(systemName: "multiply")
                                            .resizable()
                                            .frame(width: a.size.height * 0.025, height: a.size.height * 0.025)
                                            .foregroundColor(.red)
                                            .onTapGesture {
                                                self.unhideComment(commentId: hiddenCommentId)
                                        }
                                    }.padding()
                                }
                            }
                            .frame(width: a.size.width * 0.9)
                            .background(self.gameDataStore.colors["notQuiteBlack"])
                            .padding()
                            
                            Spacer()
                        }
                        .frame(width: a.size.width, height: a.size.height)
                        .foregroundColor(Color.white)
                    }

                }
                
            }
        }
        
    }
    
}
