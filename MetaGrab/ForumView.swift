//
//  ForumView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-08-17.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ForumView : View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    var gameId: Int

    func fetchNextPage() {
        self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[gameId]!, start: self.gameDataStore.forumsNextPageStartIndex[gameId]!)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if self.gameDataStore.gameBannerImage[self.gameId] != nil {
                    Image(uiImage: self.gameDataStore.gameBannerImage[self.gameId]!)
                    .resizable()
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .frame(height:100)
                }
                
                NavigationLink(destination: NewThreadView(forumId: self.gameId)) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                            .resizable()
                            .cornerRadius(10)
                            .frame(width: 30, height: 30)
                            .padding(5)
                            .background(Color.white)
                    }
                }
                .cornerRadius(3)
                .padding(.horizontal, 10)
                .offset(y: 50)
            }
            .padding(.bottom, 30)
            
            ScrollView() {
                VStack(spacing: 0) {
                    HStack {
                        Text("Threads")
                            .font(.headline)
                        Spacer()
                    }
                    
                    ForEach(self.gameDataStore.threadListByGameId[self.gameId]!, id: \.self) { threadId in
                        ThreadRow(threadId: threadId, gameId: self.gameId)
                        .cornerRadius(3)
                        .overlay(RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.gray, lineWidth: 1))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                    }
                }
            }
            
            if self.gameDataStore.forumsNextPageStartIndex[gameId] != -1 {
                Button(action: fetchNextPage) {
                    Text("Load next page")
                }
            }
        }
        .background(Image(uiImage: UIImage(named: "background")!).resizable(resizingMode: .tile))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle(Text(self.gameDataStore.games[self.gameId]!.name + " Forum"), displayMode: .inline)
        .onAppear() {
            if self.gameDataStore.isBackToGamesView {
                self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[self.gameId]!, refresh: true)
                self.gameDataStore.loadGameBanner(game: self.gameDataStore.games[self.gameId]!)
                self.gameDataStore.isBackToGamesView = false
            }
        }
    }
}

#if DEBUG
//struct ForumView_Previews : PreviewProvider {
//    static var previews: some View {
//        ForumView()
//    }
//}
#endif
