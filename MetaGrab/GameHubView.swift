//
//  GameList.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct FollowedGamesView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var body: some View {
        GeometryReader { a in
            VStack {
                if self.gameDataStore.followedGames.isEmpty != true {
                    ScrollView {
                        ForEach(self.gameDataStore.followedGames, id: \.self) { id in
                            VStack {
                                GameFeedIcon(game: self.gameDataStore.games[id]!)
                                    .frame(width: a.size.width * 0.33, height: a.size.width * 0.33 * 0.618 / 0.55)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct GameHubView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    init() {
        // To remove only extra separators below the list:
        // UITableView.appearance().tableFooterView = UIView()
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        NavigationView {
            TabView {
                PopularGamesView()
                    .tabItem {
                        Image(systemName: "flame.fill")
                        Text("Popular")
                }
                TimelineGamesView()
                    .tabItem {
                        Image(systemName: "gamecontroller.fill")
                        Text("Upcoming")
                }
                FollowedGamesView()
                    .tabItem {
                        Image(systemName: "star.circle.fill")
                        Text("Favourites")
                }
            }
            //.edgesIgnoringSafeArea(.top)
            .onAppear() {
                self.gameDataStore.fetchFollowGames(access: self.userDataStore.token!.access, userDataStore: self.userDataStore)
                self.gameDataStore.loadEmojis()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
