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
    
    var body: some View {
        NavigationLink(destination: ThreadView(threadId: threadId)) {
            VStack {
                Text(self.gameDataStore.threads[threadId]!.title)
                    .font(.title)
                Text(self.gameDataStore.threads[threadId]!.content)
                    .font(.subheadline)
            }
        }
    }
}
