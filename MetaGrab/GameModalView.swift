//
//  GameModalView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-04-30.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct GameModalView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var gameId: Int
    
    var body: some View {
        NavigationView {
            GeometryReader { a in
                VStack(alignment: .leading) {
                    
                    HStack(alignment: .center) {
                        Image(systemName: "multiply")
                        .resizable()
                        .frame(width: a.size.height * 0.025, height: a.size.height * 0.025)
                            .foregroundColor(.white)
                            .onTapGesture {
                                self.presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }
                    .frame(width: a.size.width * 0.9, height: a.size.height * 0.05, alignment: .leading)
                    .padding(.horizontal, a.size.width * 0.05)
                    .padding(.vertical, a.size.height * 0.01)
                    
                    Text(self.gameDataStore.games[self.gameId]!.name)
                        .foregroundColor(Color.white)
                        .padding(.horizontal)
                        .font(.largeTitle)
                    
                    HStack {
                        Spacer()
                        VStack {
                            if self.gameDataStore.gameBannerImage[self.gameId] != nil {
                                Image(uiImage: self.gameDataStore.gameBannerImage[self.gameId]!)
                                    .resizable()
                                    .frame(width: a.size.width * 0.8, height: a.size.height * 0.2)
                                    .scaledToFill()
                                .shadow(radius: 5)
                            }
                        }
                        .frame(width: a.size.width * 0.9, height: a.size.height * 0.25)
                        .background(self.gameDataStore.colors["notQuiteBlack"]!)
                        Spacer()
                    }
                    
                    Text("About this game")
                        .foregroundColor(Color.white)
                        .padding()
                    
                    ScrollView {
                        VStack {
                            Text(self.gameDataStore.games[self.gameId]!.gameSummary)
                                .foregroundColor(Color.white)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding()
                    .frame(width: a.size.width, height: a.size.height * 0.25)
                    
                    Text(self.gameDataStore.games[self.gameId]!.genre.name)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .shadow(radius: 5)
                        .padding()
                    
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: ForumView(gameId: self.gameId)
                            .environmentObject(self.gameDataStore)
                            .environmentObject(self.userDataStore)
                            .onAppear {
                                self.gameDataStore.isInModalView = false
                            }
                        ) {
                            HStack {
                                Text("Visit Forums")
                                Image(systemName: "chevron.right")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .shadow(radius: 5)
                            .padding()
                        }
                    }
                    .frame(width: a.size.width, height: a.size.height * 0.1)
                    Spacer()
                }
                .onAppear() {
                    self.gameDataStore.loadGameBanner(game: self.gameDataStore.games[self.gameId]!)
                    self.gameDataStore.isInModalView = true
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(self.gameDataStore.isInModalView ? true : false)
            .background(self.gameDataStore.colors["darkButNotBlack"]!)
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}
