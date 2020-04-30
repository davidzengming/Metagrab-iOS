//
//  MainHubView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-04-29.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct FrontHubView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    let gameIconWidthMultiplier: CGFloat = 0.35
    let goldenRatioConst: CGFloat = 1.618
    let widthToHeightRatio: CGFloat = 1.4
    
    let imageSizeHeightRatio: CGFloat = 0.55
    
    var body: some View {
        ZStack {
            self.gameDataStore.colors["notQuiteBlack"].edgesIgnoringSafeArea(.all)
            
            GeometryReader { a in
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: true) {
                        
                        VStack(alignment: .leading) {
                            Text("FRONT PAGE")
                                .font(.title)
                                .tracking(2)
                                .foregroundColor(Color.white)
                                .shadow(radius: 5)
                                .frame(width: a.size.width * 0.95, alignment: .leading)
                                .padding(.bottom, 10)
                            
                            Text("RECENT ACTIVITIES")
                                .foregroundColor(Color.white)
                            
                            if self.gameDataStore.followedGames.count > 0 {
                                Text("FOLLOWED GAMES")
                                    .foregroundColor(Color.white)
                                HStack {
                                    ScrollView(.horizontal, showsIndicators: true) {
                                        HStack(spacing: 20) {
                                            ForEach(self.gameDataStore.followedGames, id: \.self) { gameId in
                                                GameFeedIcon(game: self.gameDataStore.games[gameId]!)
                                                    .frame(width: a.size.width * self.gameIconWidthMultiplier, height: a.size.width * self.gameIconWidthMultiplier * 1 / self.widthToHeightRatio / self.imageSizeHeightRatio)
                                                    .shadow(radius: 5)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 5)
                                }
                            }
                        }
                        
                    }
                }
                .padding(.vertical, a.size.height * 0.05)
                .padding(.horizontal, 10)
                .onAppear() {
                    if self.gameDataStore.isFirstFetchAllGames {
                        self.gameDataStore.fetchAndSortGamesWithGenre(access: self.userDataStore.token!.access, userDataStore: self.userDataStore)
                        self.gameDataStore.isFirstFetchAllGames = false
                    }
                    self.gameDataStore.fetchFollowGames(access: self.userDataStore.token!.access, userDataStore: self.userDataStore)
                }
            }
        }
    }
}
