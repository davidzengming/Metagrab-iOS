//
//  MonthView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-02-28.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct MonthView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    
    var year: Int
    var month: Int
    var width: CGFloat
    var height: CGFloat
    
    let MONTH_ABBREV = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    func checkHasGames(year: Int, month: Int) -> Bool {
        return self.gameDataStore.gamesByYear[year] != nil && self.gameDataStore.gamesByYear[year]![month] != nil
    }
    
    func getLastIndex(arr: [Int]) -> Int {
        return arr.count - 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if self.checkHasGames(year: year, month: month) {
                Text(String(self.MONTH_ABBREV[month - 1]))
                    .font(.system(size: 60))
                    .padding()
                
                ForEach(0..<self.gameDataStore.sortedDaysListByMonthYear[year]![month]!.count, id: \.self) { dayArrIndex in
                    HStack(alignment: .top, spacing: 0) {
                        Text(String(self.gameDataStore.sortedDaysListByMonthYear[self.year]![self.month]![dayArrIndex]))
                            .font(.system(size: 30))
                            .frame(width: 100)
                        VStack(spacing: 0) {
                            ForEach(0..<self.gameDataStore.sortedGamesListByDayMonthYear[self.year]![self.month]![self.gameDataStore.sortedDaysListByMonthYear[self.year]![self.month]![dayArrIndex]]!.count, id: \.self) { gameArrIndex in
                                HStack {
                                    GeometryReader { a in
                                        ZStack {
                                            if dayArrIndex != 0 || gameArrIndex != 0 {
                                                ZStack {
                                                    Path { path in
                                                        path.move(to: CGPoint(x: a.size.width * 0.5, y: a.size.height * 0))
                                                        path.addLine(to: CGPoint(x: a.size.width * 0.5, y: a.size.height * 0.5))
                                                    }
                                                    .stroke(Color.red, lineWidth: 5)
                                                }
                                            }
                                            if dayArrIndex != self.getLastIndex(arr: self.gameDataStore.sortedDaysListByMonthYear[self.year]![self.month]!) || gameArrIndex != self.getLastIndex(arr: self.gameDataStore.sortedGamesListByDayMonthYear[self.year]![self.month]![self.gameDataStore.sortedDaysListByMonthYear[self.year]![self.month]![dayArrIndex]]!) {
                                                
                                                ZStack {
                                                    Path { path in
                                                        path.move(to: CGPoint(x: a.size.width * 0.5, y: a.size.height * 0.5))
                                                        path.addLine(to: CGPoint(x: a.size.width * 0.5, y: a.size.height * 1))
                                                    }
                                                    .stroke(Color.red, lineWidth: 5)
                                                }
                                            }
                                            
                                            ZStack {
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 30, height: 30)
                                                    .position(x: a.size.width * 0.5, y: a.size.height * 0.5)
                                                
                                                Circle()
                                                    .fill(Color.red)
                                                    .frame(width: 15, height: 15)
                                                    .position(x: a.size.width * 0.5, y: a.size.height * 0.5)
                                            }
                                            
                                        }
                                    }
                                    .frame(width: 50)
                                    
                                    Spacer()
                                    
                                    GameFeedIcon(game: self.gameDataStore.games[self.gameDataStore.sortedGamesListByDayMonthYear[self.year]![self.month]![self.gameDataStore.sortedDaysListByMonthYear[self.year]![self.month]![dayArrIndex]]![gameArrIndex]]!)
                                        .frame(width: self.width * 0.35, height: self.height * 0.25)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
