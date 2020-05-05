//
//  GameList.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct GameHubView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    init() {
        // To remove only extra separators below the list:
        // UITableView.appearance().tableFooterView = UIView()
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        //        let navBarAppearance = UINavigationBar.appearance()
        //
        //        let kern = 2
        //
        //        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.kern: kern]
        //        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white, NSAttributedString.Key.kern: kern]
        //
        
    }
    
    var body: some View {
        NavigationView {
            TabView {
                FrontHubView()
                    .navigationBarTitle("Front")
                    .navigationBarHidden(true)
                    .tabItem {
                        Image(systemName: "square.stack.3d.up.fill")
                        Text("Front")
                }
                
                PopularGamesView()
                    .navigationBarTitle("Popular")
                    .navigationBarHidden(true)
                    .tabItem {
                        Image(systemName: "flame.fill")
                        Text("Popular")
                }
                
                TimelineGamesView()
                    .navigationBarTitle("Upcoming")
                    .navigationBarHidden(true)
                    .tabItem {
                        Image(systemName: "hourglass.bottomhalf.fill")
                        Text("Upcoming")
                }
            }
                //.edgesIgnoringSafeArea(.top)
                .onAppear() {
                    self.gameDataStore.fetchFollowGames(access: self.userDataStore.token!.access, userDataStore: self.userDataStore)
                    self.gameDataStore.loadEmojis()
                    self.gameDataStore.loadColors()
                    self.gameDataStore.loadLeadingLineColors()
                    self.gameDataStore.getGameHistory(access: self.userDataStore.token!.access)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
