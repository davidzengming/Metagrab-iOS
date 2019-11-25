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
        self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[gameId]!, start: self.gameDataStore.forumsNextPageStartIndex[gameId]!)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                NavigationLink(destination: NewThreadView(forumId: gameId)) {
                    Text("POST")
                }
                .frame(width: 100, height: 50, alignment: .center)
                .background(Color.orange)
                .cornerRadius(5)
            }
            
            ScrollView {
                ForEach(self.gameDataStore.threadListByGameId[self.gameId]!, id: \.self) { threadId in
                    ThreadRow(threadId: threadId)
                        .padding(.all, 20)
                }
            }
            
            if self.gameDataStore.forumsNextPageStartIndex[gameId] != -1 {
                Button(action: fetchNextPage) {
                    Text("Click me for more Threads")
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
