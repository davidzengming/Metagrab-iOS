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
    
    @State var showModal = false
    
    let placeholder = Image(systemName: "photo")
    
    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        GeometryReader { a in
            VStack(spacing: 0) {
                HStack {
                    if (self.gameDataStore.gameIcons[self.game.id] != nil) {
                        Image(uiImage: self.gameDataStore.gameIcons[self.game.id]!)
                            .resizable()
                            .frame(width: a.size.width, height: a.size.height * 0.6)
                    } else {
                        self.placeholder
                            .frame(width: a.size.width, height: a.size.height * 0.6)
                    }
                }.onAppear{
                    self.gameDataStore.loadGameIcon(game: self.game)
                    self.gameDataStore.isBackToGamesView = true
                }
                
                HStack(spacing: 0) {
                    
                    Button(action: {
                        self.showModal.toggle()
                    }) {
                        Image(systemName: "gamecontroller.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(a.size.width * 0.07)
                            .foregroundColor(Color.orange)
                            .frame(width: a.size.width / 2, height: a.size.height * 0.2)
                    }
                    .sheet(isPresented: self.$showModal) {
                        GameModalView(gameId: self.game.id)
                            .environmentObject(self.gameDataStore)
                            .environmentObject(self.userDataStore)
                    }
                    
                    NavigationLink(destination: ForumView(gameId: self.game.id)) {
                        Image(uiImage: UIImage(systemName: "text.bubble.fill")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(a.size.width * 0.07)
                            .frame(width: a.size.width / 2, height: a.size.height * 0.2)
                    }
                }
                .background(self.gameDataStore.colors["notQuiteBlack"]!)
            }
        }
    }
}

