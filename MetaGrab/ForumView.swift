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
        // for navigation bar title color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        // For navigation bar background color
        UINavigationBar.appearance().barTintColor = hexStringToUIColor(hex: "#2C2F33")
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default) makes status bar translucent
        UINavigationBar.appearance().backgroundColor = hexStringToUIColor(hex: "#2C2F33")
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func followGame() {
        self.gameDataStore.followGame(access: userDataStore.token!.access, game: self.gameDataStore.games[gameId]!)
    }
    
    func unfollowGame() {
        self.gameDataStore.unfollowGame(access: userDataStore.token!.access, game: self.gameDataStore.games[gameId]!)
    }
    
    func fetchNextPage() {
        self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[self.gameId]!, start: self.gameDataStore.forumsNextPageStartIndex[self.gameId]!, userId: self.userDataStore.token!.userId)
    }
    
    var body: some View {
        ZStack {
            self.gameDataStore.colors["darkButNotBlack"]!
                .edgesIgnoringSafeArea(.all)
            
            GeometryReader { a in
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        ScrollView(.vertical) {
                            VStack(spacing: 0) {
                                VStack {
                                    HStack {
                                        if self.gameDataStore.gameBannerImage[self.gameId] != nil {
                                            Image(uiImage: self.gameDataStore.gameIcons[self.gameId]!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: a.size.width * 0.13, height: a.size.width * 0.13, alignment: .leading)
                                                .cornerRadius(5, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.white, lineWidth: 2)
                                            )
                                        }
                                        VStack(alignment: .leading) {
                                            Text(self.gameDataStore.games[self.gameId]!.name)
                                                .foregroundColor(Color.white)
                                                .bold()
                                            
                                            Text(self.gameDataStore.games[self.gameId]!.genre.name)
                                                .foregroundColor(Color.white)
                                                .bold()
                                        }
                                        Spacer()
                                        
                                        Text("Follow")
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .foregroundColor(self.gameDataStore.isFollowed[self.gameId]! == true ? Color.white : Color.black)
                                            .background(self.gameDataStore.isFollowed[self.gameId]! == true ? Color.black : Color.white)
                                            .cornerRadius(30)
                                            .shadow(radius: 5)
                                            .onTapGesture {
                                                if self.gameDataStore.isFollowed[self.gameId]! == true {
                                                    self.unfollowGame()
                                                } else {
                                                    self.followGame()
                                                }
                                        }
                                    }
                                    .frame(width: a.size.width * 0.8)
                                }
                                .frame(width: a.size.width, height: a.size.width * 0.13)
                                .padding(.top, 30)
                                
                                ZStack {
                                    VStack {
                                        Spacer()
                                        Color.gray
                                            .frame(width: a.size.width, height: a.size.height * 0.06)
                                    }
                                    
                                    VStack {
                                        Spacer()
                                        VStack {
                                            Text("Number of threads: " + String(self.gameDataStore.games[self.gameId]!.threadCount))
                                        }
                                        .frame(width: a.size.width * 0.8, height: a.size.height * 0.075)
                                        .background(Color.white)
                                        .cornerRadius(5, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
                                        
                                        Spacer()
                                    }
                                }
                                .frame(width: a.size.width, height: a.size.height * 0.12)
                                
                                VStack {
                                    if !self.gameDataStore.threadListByGameId[self.gameId]!.isEmpty {
                                        ForEach(self.gameDataStore.threadListByGameId[self.gameId]!, id: \.self) { threadId in
                                            VStack {
                                                ThreadRow(threadId: threadId, gameId: self.gameId, width: a.size.width * 0.9, height: a.size.height)
                                                    .background(Color.white)
                                                    .frame(width: a.size.width, height: a.size.height * 0.045 + 10 + 10 + (self.gameDataStore.threads[threadId]!.title.count > 0 ? 16 : 0) + min(self.gameDataStore.threadsDesiredHeight[threadId]!, 200)
                                                        
                                                        + 10
                                                        
                                                        + (self.gameDataStore.threadImagesHeight[threadId] == nil ? 0 : max(a.size.height * 0.1, min(a.size.height * 0.15, self.gameDataStore.threadImagesHeight[threadId]!)) + 20)
                                                        
                                                        + a.size.height * 0.025 + CGFloat(self.gameDataStore.emojiArrByThreadId[threadId]!.count) * 30 + 40 + 20 + 20)
                                                    
                                                Divider()
                                            }
                                        }
                                    } else {
                                        VStack {
                                            Text("Be the first explorer to post in this game :D")
                                        }
                                        .frame(width: a.size.width, height: a.size.height)
                                    }
                                }
                                .background(Color.white)
                                .frame(width: a.size.width)
                                .background(self.gameDataStore.colors["darkButNotBlack"])
                                
                                if self.gameDataStore.forumsNextPageStartIndex[self.gameId] != nil && self.gameDataStore.forumsNextPageStartIndex[self.gameId]! != -1 {
                                    HStack(alignment: .center) {
                                        Spacer()
                                        Image(systemName: "chevron.compact.down")
                                            .foregroundColor(Color.white)
                                            .padding(.top, 10)
                                            .padding(.horizontal, 20)
                                            .padding(.bottom, 10)
                                        Spacer()
                                        Image(systemName: "chevron.compact.down")
                                            .foregroundColor(Color.white)
                                            .padding(.top, 10)
                                            .padding(.horizontal, 20)
                                            .padding(.bottom, 10)
                                        Spacer()
                                        Image(systemName: "chevron.compact.down")
                                            .foregroundColor(Color.white)
                                            .padding(.top, 10)
                                            .padding(.horizontal, 20)
                                            .padding(.bottom, 10)
                                        Spacer()
                                    }
                                        
                                    .frame(width: a.size.width, height: a.size.height * 0.05)
                                    .background(self.gameDataStore.colors["darkButNotBlack"]!)
                                    .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                                    .shadow(radius: 5)
                                    .onTapGesture {
                                        self.fetchNextPage()
                                    }
                                }
                            }
                        }
                        .frame(width: a.size.width, height: a.size.height)
//                        .frame(width: a.size.width, height: self.gameDataStore.forumsNextPageStartIndex[self.gameId] != nil && self.gameDataStore.forumsNextPageStartIndex[self.gameId]! != -1 ? a.size.height * 0.95 : a.size.height)
                    }
                        
                    .navigationBarTitle(Text(self.gameDataStore.games[self.gameId]!.name + " Board"), displayMode: .inline)
                    .onAppear() {
                        if self.gameDataStore.isBackToGamesView {
                            self.gameDataStore.fetchThreads(access: self.userDataStore.token!.access, game: self.gameDataStore.games[self.gameId]!, refresh: true, userId: self.userDataStore.token!.userId)
                            self.gameDataStore.loadGameBanner(game: self.gameDataStore.games[self.gameId]!)
                            self.gameDataStore.isBackToGamesView = false
                        }
                        
                        self.gameDataStore.insertGameHistory(access: self.userDataStore.token!.access, gameId: self.gameId)
                    }
                    
                    NavigationLink(destination: NewThreadView(forumId: self.gameId)) {
                        NewThreadButton()
                            .frame(width: min(a.size.width, a.size.height) * 0.12, height: min(a.size.width, a.size.height) * 0.12, alignment: .center)
                            .shadow(radius: 10)
                    }
                    .position(x: a.size.width * 0.88, y: a.size.height * 0.85)
                    
                    if self.gameDataStore.isAddEmojiModalActiveByForumId[self.gameId] == true {
                        VStack {
                            EmojiPickerPopupView(parentForumId: self.gameId)
                                .frame(width: a.size.width, height: a.size.height * 0.2)
                                .background(self.gameDataStore.colors["darkButNotBlack"]!)
                                .cornerRadius(5, corners: [.topLeft, .topRight])
                                .KeyboardAwarePadding()
                        }
                        .background(Color.white)
                        .transition(.move(edge: .bottom))
                        .animation(.spring())
                    }
                }
            }
            .background(Image("background").resizable(resizingMode: .tile))
            .edgesIgnoringSafeArea(.bottom)
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
