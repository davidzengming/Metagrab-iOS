//
//  FollowGameIcon.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct FollowGameIcon: View {
    var game: Game
    @EnvironmentObject var userDataStore: UserDataStore
    @EnvironmentObject var gameDataStore: GameDataStore

    let placeholder = Image(systemName: "photo")

    init(game: Game) {
        self.game = game
    }
    
    func followGame() {
        self.gameDataStore.followGame(access: userDataStore.token!.access, game: game)
    }
    
    func unfollowGame() {
        self.gameDataStore.unfollowGame(access: userDataStore.token!.access, game: game)
    }
    
    var body: some View {
        VStack {
            if (self.gameDataStore.gameIcons[game.id] != nil) {
                Button(action: {
                    if self.gameDataStore.isFollowed[self.game.id] == true {
                        self.unfollowGame()
                    } else {
                        self.followGame()
                    }
                }) {
                    Image(uiImage: self.gameDataStore.gameIcons[game.id]!)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .border(self.gameDataStore.isFollowed[self.game.id] == true ? Color.green : Color.red, width: 4)
                }
            } else {
                placeholder
                    .frame(width: 100, height: 100)
            }
        }.onAppear() {
            self.gameDataStore.loadGameIcon(game: self.game)
        }
    }
}
