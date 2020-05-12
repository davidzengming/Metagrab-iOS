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
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text(self.gameDataStore.games[self.gameId]!.name.uppercased())
                                .tracking(2)
                                .foregroundColor(Color.white)
                                .padding(.horizontal)
                                .font(.system(size: 30))
                            
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
                                .frame(width: a.size.width * 0.9, height: a.size.height * 0.15)
                                .background(self.gameDataStore.colors["notQuiteBlack"]!)
                                Spacer()
                            }
                            .padding(.vertical, 20)
                            
                            Text("ABOUT THIS GAME")
                                .tracking(1)
                                .foregroundColor(Color.white)
                                .padding(.top)
                                .padding(.horizontal)
                            
                            Rectangle()
                                .frame(width: a.size.width * 0.9, height: 1)
                                .foregroundColor(.clear)
                                .background(LinearGradient(gradient: Gradient(colors: [.blue, self.gameDataStore.colors["notQuiteBlack"]!]), startPoint: .leading, endPoint: .trailing))
                                .padding(.horizontal)
                            
                            VStack {
                                Text(self.gameDataStore.games[self.gameId]!.gameSummary)
                                    .foregroundColor(Color.white)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("GENRE: ")
                                            .font(.system(size: 16))
                                            .tracking(1)
                                            .foregroundColor(Color.gray)
                                        
                                        Text(self.gameDataStore.games[self.gameId]!.genre.name)
                                            .font(.system(size: 16))
                                            .tracking(1)
                                            .foregroundColor(Color(UIColor.systemTeal))
                                    }
                                    .padding(.vertical, 5)
                                    
                                    HStack {
                                        Text("DEVELOPER: ")
                                            .font(.system(size: 16))
                                            .tracking(1)
                                            .foregroundColor(Color.gray)
                                        
                                        Text(self.gameDataStore.games[self.gameId]!.developer.name)
                                            .font(.system(size: 16))
                                            .tracking(1)
                                            .foregroundColor(Color(UIColor.systemTeal))
                                    }
                                    .padding(.vertical, 5)
                                    
                                    HStack {
                                        Text("PUBLISHER: ")
                                            .font(.system(size: 16))
                                            .tracking(1)
                                            .foregroundColor(Color.gray)
                                        
                                        Text(self.gameDataStore.games[self.gameId]!.developer.name)
                                            .font(.system(size: 16))
                                            .tracking(1)
                                            .foregroundColor(Color(UIColor.systemTeal))
                                    }
                                    .padding(.vertical, 5)
                                    
                                    Spacer()
                                    HStack {
                                        NavigationLink(destination: ForumView(gameId: self.gameId)
                                            .environmentObject(self.gameDataStore)
                                            .environmentObject(self.userDataStore)
                                            .onAppear {
                                                self.gameDataStore.isInModalView = false
                                            }
                                        ) {
                                            HStack {
                                                Text("Visit discussion")
                                                .tracking(1)
                                            }
                                            .foregroundColor(Color.white)
                                            .padding(.horizontal)
                                            .padding(.vertical, 10)
                                            .shadow(radius: 5)
                                        }
                                        Spacer()
                                    }
                                    .background(self.gameDataStore.colors["darkButNotBlack"]!)
                                }
                                .padding()
                            }
                                
                            .frame(width: a.size.width * 0.9, alignment: .leading)
                            .background(self.gameDataStore.colors["notQuiteBlack"]!)
                            .padding()
                            
                            Spacer()
                        }
                    }
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
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
