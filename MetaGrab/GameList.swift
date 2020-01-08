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
    @State var followTab: Int = 0
    
    var followTabs = ["Popular", "Timeline"]
    
    var body: some View {
        VStack {
            Button(action: dismiss) {
                Text("Dismiss")
            }
            .padding()
            
            Picker("FollowTab", selection: $followTab) {
                ForEach(0 ..< followTabs.count) { index in
                    Text(self.followTabs[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 50)
            
            if followTab == 0 {
                PopularGamesView()
            } else {
                TimelineGamesView()
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
