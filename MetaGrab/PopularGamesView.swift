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
    
    let gameIconWidthMultiplier: CGFloat = 0.35
    let goldenRatioConst: CGFloat = 1.618
    let widthToHeightRatio: CGFloat = 1.4
    
    let imageSizeHeightRatio: CGFloat = 0.55
    
    var body: some View {
        GeometryReader { a in
            VStack {
                Text(self.userDataStore.username!)
                // There's a bug with scrollview - list, using forEach for now
                // Bug 2 - If there is only my VStack inside ScrollView, it does not appear until I have clicked/dragged near the area then it appears. Works fine with the HStack inside here for some reason.
                ScrollView(.vertical, showsIndicators: true) {
                    if self.gameDataStore.genreGameArray.count != 0 {
                        VStack {
                            ForEach(self.gameDataStore.genreGameArray.keys.sorted(), id: \.self) { key in
                                VStack(spacing: 0) {
                                    if self.gameDataStore.genreGameArray[key]!.count > 0 {
                                        Text(self.gameDataStore.genres[key]!.name)
                                            .font(.system(size: 20))
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 20) {
                                                ForEach(self.gameDataStore.genreGameArray[key]!, id: \.self) { gameId in
                                                    GameFeedIcon(game: self.gameDataStore.games[gameId]!)
                                                        .frame(width: a.size.width * self.gameIconWidthMultiplier, height: a.size.width * self.gameIconWidthMultiplier * 1 / self.widthToHeightRatio / self.imageSizeHeightRatio)
                                                }
                                            }
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
}
