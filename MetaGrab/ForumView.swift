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
    
    init(gameId: Int) {
        // To remove only extra separators below the list:
        // UITableView.appearance().tableFooterView = UIView()
        
        self.gameId = gameId
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[self.gameId]!, start: self.gameDataStore.forumsNextPageStartIndex[self.gameId]!)
    }
    
    var body: some View {
        GeometryReader { a in
            VStack(spacing: 0) {
                ScrollView(.vertical) {
                    VStack {
                        HStack {
                            if self.gameDataStore.gameBannerImage[self.gameId] != nil {
                                Image(uiImage: self.gameDataStore.gameBannerImage[self.gameId]!)
                                    .resizable()
                                    .frame(width: a.size.width * 0.15, height: a.size.width * 0.15, alignment: .leading)
                                    .cornerRadius(5, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.white, lineWidth: 2)
                                )
                            }
                            Text(self.gameDataStore.games[self.gameId]!.name)
                                .foregroundColor(Color.white)
                        }
                    }
                    .frame(width: a.size.width, height: a.size.height * 0.2)
                    .background(Image(uiImage: UIImage(named: "background")!).resizable(resizingMode: .tile))
                    
                    VStack {
                        if !self.gameDataStore.threadListByGameId[self.gameId]!.isEmpty {
                            ForEach(self.gameDataStore.threadListByGameId[self.gameId]!, id: \.self) { threadId in
                                VStack {
                                    ThreadRow(threadId: threadId, gameId: self.gameId, width: a.size.width * 0.9, height: a.size.height)
                                        .background(Color.white)
                                    Divider()
                                }
                            }
                        }
                    }
                    .frame(width: a.size.width)
                }
                .frame(width: a.size.width, height: self.gameDataStore.forumsNextPageStartIndex[self.gameId] != nil && self.gameDataStore.forumsNextPageStartIndex[self.gameId]! != -1 ? a.size.height * 0.95 : a.size.height)
                
                if self.gameDataStore.forumsNextPageStartIndex[self.gameId] != nil && self.gameDataStore.forumsNextPageStartIndex[self.gameId]! != -1 {
                    Image(uiImage: UIImage(systemName: "chevron.compact.down")!)
                        .onTapGesture {
                            self.fetchNextPage()
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                    .background(Color.yellow)
                    .frame(height: a.size.height * 0.05)
                }
            }
            
            .navigationBarTitle(Text(self.gameDataStore.games[self.gameId]!.name + " Board"), displayMode: .inline)
            .onAppear() {
                if self.gameDataStore.isBackToGamesView {
                    self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[self.gameId]!, refresh: true)
                    self.gameDataStore.loadGameBanner(game: self.gameDataStore.games[self.gameId]!)
                    self.gameDataStore.isBackToGamesView = false
                }
            }
            
            NavigationLink(destination: NewThreadView(forumId: self.gameId)) {
                NewThreadButton()
                    .frame(width: min(a.size.width, a.size.height) * 0.12, height: min(a.size.width, a.size.height) * 0.12, alignment: .center)
                    .shadow(radius: 10)
            }
            .position(x: a.size.width * 0.88, y: a.size.height * 0.85)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#if DEBUG
//struct ForumView_Previews : PreviewProvider {
//    static var previews: some View {
//        ForumView()
//    }
//}
#endif
