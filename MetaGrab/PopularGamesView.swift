//
//  PopularGamesView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-12-16.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct PopularGamesView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var body: some View {
        VStack {
            // There's a bug with scrollview - list, using forEach for now
            // Bug 2 - If there is only my VStack inside ScrollView, it does not appear until I have clicked/dragged near the area then it appears. Works fine with the HStack inside here for some reason.
            ScrollView(.vertical, showsIndicators: true) {
                HStack {
                    Text("Game Library")
                        .font(.headline)
                    Spacer()
                }
                VStack {
                    ForEach(self.gameDataStore.genreGameArray.keys.sorted(), id: \.self) { key in
                        Group {
                            Text(self.gameDataStore.genres[key]!.name)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(self.gameDataStore.genreGameArray[key]!, id: \.self) { gameId in
                                            FollowGameIcon(game: self.gameDataStore.games[gameId]!)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear() {
                if self.gameDataStore.isFirstFetchAllGames {
                    self.gameDataStore.fetchAndSortGamesWithGenre(access: self.userDataStore.token!.access, userDataStore: self.userDataStore)
                    self.gameDataStore.isFirstFetchAllGames = false
                }
            }
        }
    }
}
