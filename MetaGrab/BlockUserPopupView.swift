//
//  BlockUserPopupView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-05-13.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct BlockUserPopupView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var forumId: Int?
    var threadId: Int?
    
    func dismissView() {
        if forumId != nil {
            self.gameDataStore.isBlockPopupActiveByForumId[forumId!] = false
        } else {
            self.gameDataStore.isBlockPopupActiveByThreadId[threadId!] = false
        }
    }
    
    func blockUser() {
        if forumId != nil {
            self.gameDataStore.blockUser(access: self.userDataStore.token!.access, userId: self.userDataStore.token!.userId, targetBlockUserId: self.gameDataStore.lastClickedBlockUserByForumId[forumId!]!)
        } else {
            self.gameDataStore.blockUser(access: self.userDataStore.token!.access, userId: self.userDataStore.token!.userId, targetBlockUserId: self.gameDataStore.lastClickedBlockUserByThreadId[threadId!]!)
        }
        
        self.dismissView()
    }
    
    var body: some View {
        GeometryReader { a in
            VStack {
                HStack(alignment: .center) {
                    Image(systemName: "multiply")
                    .resizable()
                    .frame(width: a.size.height * 0.1, height: a.size.height * 0.1)
                        .foregroundColor(.white)
                        .onTapGesture {
                            self.dismissView()
                    }
                    Spacer()
                }
                .frame(width: a.size.width * 0.9, height: a.size.height * 0.1, alignment: .leading)
                .padding(.horizontal, a.size.width * 0.05)
                .padding(.vertical, a.size.height * 0.1)
                
                Button(action: self.blockUser) {
                    Text("Block " + (self.forumId != nil ? self.gameDataStore.users[self.gameDataStore.lastClickedBlockUserByForumId[self.forumId!]!]!.username : self.gameDataStore.users[self.gameDataStore.lastClickedBlockUserByThreadId[self.threadId!]!]!.username))
                    .padding(7)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                }
                .padding(.top, 10)
                Spacer()
            }
        }
    }
}
