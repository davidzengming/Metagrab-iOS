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
                
                VStack {
                    Button(action: {
                        if self.gameDataStore.isFollowed[self.game.id] == true {
                            self.unfollowGame()
                        } else {
                            self.followGame()
                        }
                    }) {
                        if self.gameDataStore.isFollowed[self.game.id] == true {
                            Text("Followed")
                                .font(.system(size: a.size.height / 15))
                        } else {
                            Text("Follow")
                                .font(.system(size: a.size.height / 15))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: a.size.width, height: a.size.height * 0.10)
                    .background(self.gameDataStore.isFollowed[self.game.id] == true ? Color.green : Color.red)

                    HStack {
                        NavigationLink(destination: ForumView(gameId: self.game.id)) {
                            Text("Discuss")
                                .font(.system(size: a.size.height / 15))
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding()
                    }
                    .frame(width: a.size.width, height: a.size.height * 0.10)
                    .background(Color.orange)
                    .cornerRadius(5, corners: [.bottomLeft, .bottomRight])
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

