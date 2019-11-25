//
//  GameList.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct FollowGamesView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var body: some View {
        VStack {
            Button(action: dismiss) {
                Text("Dismiss")
            }
            .padding()
            .onAppear() {
                self.gameDataStore.fetchAndSortGamesWithGenre(access: self.userDataStore.token!.access, userDataStore: self.userDataStore)
                print("wow")
            }

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
        }
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct FollowGameParentView: View {
    @State var isFollowGamesPresented = false
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var body: some View {
        Button(action: {
            self.isFollowGamesPresented.toggle()
        }) {
            Text("Follow Games")
        }
        .sheet(isPresented: $isFollowGamesPresented, content: {
            FollowGamesView()
            .environmentObject(self.userDataStore)
            .environmentObject(self.gameDataStore)
        })
    }
}

struct GameList: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var body: some View {
        VStack {
            FollowGameParentView()
            List(self.gameDataStore.followedGames, id: \.self) { id in
                GameFeedRow(game: self.gameDataStore.games[id]!)
            }.onAppear() {
                self.gameDataStore.fetchFollowGames(access: self.userDataStore.token!.access, userDataStore: self.userDataStore)
            }.navigationBarTitle(Text("Games"))
        }
    }
}

#if DEBUG
struct GameList_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("Hi")
        }
    }
}
#endif
