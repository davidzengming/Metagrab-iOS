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
                    
                    VStack {
                        Text("Blacklist")
                        
                        ForEach(self.gameDataStore.blacklistedUserIdArr, id: \.self) { blacklistedUserId in
                            Text(self.gameDataStore.blacklistedUsersById[blacklistedUserId]!.username)
                        }
                    }
                    
                    VStack {
                        Text("Hidden Threads")
                        
                        ForEach(self.gameDataStore.hiddenThreadIdArr, id: \.self) { hiddenThreadId in
                            Text(self.gameDataStore.hiddenThreadsById[hiddenThreadId]!.title)
                        }
                    }
                    
                    VStack {
                        Text("Hidden Comments")
                        
                        ForEach(self.gameDataStore.hiddenCommentIdArr, id: \.self) { hiddenCommentId in
                            Text(self.gameDataStore.hiddenCommentsById[hiddenCommentId]!.contentString)
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: a.size.width, height: a.size.height)
            }
            .onAppear() {
                self.gameDataStore.fetchBlacklistedUsers(access: self.userDataStore.token!.access, userId: self.userDataStore.token!.userId)
                self.gameDataStore.fetchHiddenThreads(access: self.userDataStore.token!.access, userId: self.userDataStore.token!.userId)
                self.gameDataStore.fetchHiddenComments(access: self.userDataStore.token!.access, userId: self.userDataStore.token!.userId)
            }
        }
    }
}
