//
//  ForumView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct ForumView : View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    var gameId: Int
    
    func fetchNextPage() {
        self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[gameId]!, fetchNextPage: true)
    }
    
    var body: some View {
        VStack {
            NavigationLink(destination: NewThreadView(forumId: gameId)) {
                HStack {
                    Spacer()
                    Text("Post thread")
                }
            }
            List(self.gameDataStore.threadListByGameId[self.gameId]!, id: \.self) { threadId in
                ThreadRow(threadId: threadId)
            }
            
            if self.gameDataStore.threadCursorByForumId[gameId] != nil {
                Button(action: fetchNextPage) {
                    Text("More Threads")
                }
            }
            
        }
        .navigationBarTitle(Text(self.gameDataStore.games[gameId]!.name + " Forum"))
    }
}

#if DEBUG
//struct ForumView_Previews : PreviewProvider {
//    static var previews: some View {
//        ForumView()
//    }
//}
#endif
