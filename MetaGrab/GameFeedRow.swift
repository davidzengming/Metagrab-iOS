//
//  GameFeedRow.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct GameFeedRow : View {
    var game: Game
    @State private var showDetail = false
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    let placeholder = Image(systemName: "photo")

    init(game: Game) {
        self.game = game
    }
    
    var body: some View {
        VStack {
            HStack {
                if (self.gameDataStore.gameIcons[game.id] != nil) {
                    Image(uiImage: self.gameDataStore.gameIcons[game.id]!)
                        .resizable()
                        .frame(width: 100, height: 75)
                } else {
                    placeholder
                        .frame(width: 100, height: 75)
                }
                Text(game.name)
                Spacer()
                Text("Expand").onTapGesture {
                    self.showDetail.toggle()
                }
            }.onAppear{
                self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.game)
            }

            HStack {
                if showDetail {
                    Text(game.genre.name)
                    Text(String(game.id))
                    NavigationLink(destination: ForumView(gameId: game.id)) {
                        Text("Go to game forums")
                    }.padding()
                }
            }
        }.onAppear() {
            self.gameDataStore.loadGameIcon(game: self.game)
        }
    }
}

#if DEBUG
struct GameFeedRow_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            GameFeedRow(game: Game(id: 4, name: "Resident Evil 2", releaseDate: Date.init(), developer: Developer(id: 1, name: "Valve"), lastUpdated: Date.init(), genre: Genre(id: 2, name: "First Person Shooter"), icon: "https://upload.wikimedia.org/wikipedia/en/thumb/f/fd/Resident_Evil_2_Remake.jpg/220px-Resident_Evil_2_Remake.jpg"))
        }
    }
}
#endif
