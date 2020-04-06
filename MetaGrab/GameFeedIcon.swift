//
//  GameFeedIcon.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct GameFeedIcon : View {
    var game: Game
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
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
        GeometryReader { a in
            VStack(spacing: 0) {
                HStack {
                    if (self.gameDataStore.gameIcons[self.game.id] != nil) {
                        Image(uiImage: self.gameDataStore.gameIcons[self.game.id]!)
                            .resizable()
                            .frame(width: a.size.width, height: a.size.height * 0.6)
                            .cornerRadius(5, corners: [.topLeft, .topRight])
                    } else {
                        self.placeholder
                            .frame(width: a.size.width, height: a.size.height * 0.6)
                            .cornerRadius(5, corners: [.topLeft, .topRight])
                    }
                }.onAppear{
                    self.gameDataStore.loadGameIcon(game: self.game)
                    self.gameDataStore.isBackToGamesView = true
                }
                
                HStack(spacing: 0) {
                    Image(systemName: self.gameDataStore.isFollowed[self.game.id] == true ? "star.fill" : "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(10)
                        .foregroundColor(Color.yellow)
                        .frame(width: a.size.width / 2, height: a.size.height * 0.2)
                        .onTapGesture {
                            if self.gameDataStore.isFollowed[self.game.id] == true {
                                self.unfollowGame()
                            } else {
                                self.followGame()
                            }
                    }
                    
                    NavigationLink(destination: ForumView(gameId: self.game.id)) {
                        Image(uiImage: UIImage(systemName: "text.bubble.fill")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(10)
                            .frame(width: a.size.width / 2, height: a.size.height * 0.2)
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            )
                .shadow(radius: 5)
        }
    }
}

