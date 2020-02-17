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
    
    var body: some View {
        GeometryReader { a in
            VStack(spacing: 0) {
                if self.gameDataStore.gameBannerImage[self.gameId] != nil {
                    Image(uiImage: self.gameDataStore.gameBannerImage[self.gameId]!)
                    .resizable()
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                        .frame(height: a.size.height * 0.15)
                }
                
                List {
                    ForEach(self.gameDataStore.threadListByGameId[self.gameId]!, id: \.self) { threadId in
                        VStack {
                            ThreadRow(threadId: threadId, gameId: self.gameId)
                                    .frame(width: a.size.width, height: self.gameDataStore.threadsDesiredHeight[threadId] != nil ? self.gameDataStore.threadsDesiredHeight[threadId]!: 200, alignment: .center)
                                    .padding(.vertical, 10)
                            
                            if self.gameDataStore.threadsDesiredHeight[threadId] != nil {
                                Text(String(Double(self.gameDataStore.threadsDesiredHeight[threadId]!)))
                            }
                        }
                    }.background(Color.yellow)
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
            
            NavigationLink(destination: NewThreadView(forumId: self.gameId)) {
                NewThreadButton()
                .frame(width: min(a.size.width, a.size.height) * 0.10, height: min(a.size.width, a.size.height) * 0.10, alignment: .center)
                .shadow(radius: 5)
                    
            }
            .position(x: a.size.width * 0.87, y: a.size.height * 0.90)
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
