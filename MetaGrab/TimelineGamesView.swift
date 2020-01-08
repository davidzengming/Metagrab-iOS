//
//  TimelineGamesView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-12-16.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import SwiftUI

struct TimelineGamesView: View {
    @EnvironmentObject var gameDataStore: GameDataStore
    @EnvironmentObject var userDataStore: UserDataStore
    let date = Date()
    let calendar = Calendar.current
    let MONTH_ABBREV = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    func calcRangeStartMonth() -> Int {
        print((calendar.component(.month, from: date) - 2) % 12, "start", (calendar.component(.month, from: date), "kew"))
        return (calendar.component(.month, from: date) - 2)
    }
    
    func getCurrentYear() -> Int {
        return (calendar.component(.year, from: date))
    }
    
    func getCurrentMonth() -> Int {
        return (calendar.component(.month, from: date))
    }
    
    func checkHasGames(year: Int, month: Int) -> Bool {
        return self.gameDataStore.gamesByYear[year] != nil && self.gameDataStore.gamesByYear[year]![month] != nil
    }
    
    func getSortedMonthGameList(year: Int, month: Int) -> [Int] {
        return Array(self.gameDataStore.gamesByYear[year]![month]!.keys).sorted{$0 < $1}
    }
    
    func mod(_ a: Int, _ n: Int) -> Int {
        precondition(n > 0, "modulus must be positive")
        let r = a % n
        return r >= 0 ? r : r + n
    }

    
    func checkPrevMonthsHasGamesRelease() -> Bool {
        for month in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].suffix(mod(calcRangeStartMonth(), 12)) {
            if checkHasGames(year: self.getCurrentYear() - 1, month: month) {
                return true
            }
        }
        return false
    }
    
    // Lists recent games is past 2 months and upcoming games 1 year down the road
    var body: some View {
        ScrollView {
            VStack {
                // Previous year
                if checkPrevMonthsHasGamesRelease() == true {
                    Text(String(self.getCurrentYear() - 1))
                    ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].suffix(mod(calcRangeStartMonth(), 12)), id: \.self) { month in
                        VStack(spacing: 0) {
                            if self.checkHasGames(year: self.getCurrentYear() - 1, month: month) {
                                Text(String(self.MONTH_ABBREV[month - 1]))
                                    .font(.headline)
                                ForEach(self.getSortedMonthGameList(year: self.getCurrentYear() - 1, month: month), id: \.self) { day in
                                    HStack {
                                        Text(String(day))
                                            .padding(.horizontal, 100)
                                        ZStack {
                                            Rectangle()
                                            .fill(Color.red)
                                            .frame(width: 10, height: 150)
                                            Circle()
                                            .fill(Color.black)
                                            .frame(width: 20, height: 50)
                                        }
                                        Spacer()
                                        ForEach(Array(self.gameDataStore.gamesByYear[self.getCurrentYear() - 1]![month]![day]!), id: \.self) { gameId in
                                            HStack {
                                                FollowGameIcon(game: self.gameDataStore.games[gameId]!)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                Text(String(self.getCurrentYear()))
                // Current year
                ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], id: \.self) { month in
                    VStack(spacing: 0) {
                        if self.checkHasGames(year: self.getCurrentYear(), month: month) {
                            Text(String(self.MONTH_ABBREV[month - 1]))
                                .font(.headline)
                            ForEach(self.getSortedMonthGameList(year: self.getCurrentYear(), month: month), id: \.self) { day in
                                HStack {
                                    Text(String(day))
                                    ZStack {
                                        Rectangle()
                                        .fill(Color.red)
                                        .frame(width: 10, height: 150)
                                        Circle()
                                        .fill(Color.black)
                                        .frame(width: 20, height: 50)
                                    }
                                    Spacer()
                                    ForEach(Array(self.gameDataStore.gamesByYear[self.getCurrentYear()]![month]![day]!), id: \.self) { gameId in
                                        HStack {
                                            FollowGameIcon(game: self.gameDataStore.games[gameId]!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Next year
                if calcRangeStartMonth() > 1 {
                    Text(String(self.getCurrentYear() + 1))
                    ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].prefix(getCurrentMonth()), id: \.self) { month in
                        VStack(spacing: 0) {
                            if self.checkHasGames(year: self.getCurrentYear() + 1, month: month) {
                                Text(String(self.MONTH_ABBREV[month - 1]))
                                    .font(.headline)
                                ForEach(self.getSortedMonthGameList(year: self.getCurrentYear() + 1, month: month), id: \.self) { day in
                                    HStack {
                                        Text(String(day))
                                            .frame(width: 100)
                                        ZStack {
                                            Rectangle()
                                            .fill(Color.red)
                                            .frame(width: 10, height: 150)
                                            Circle()
                                            .fill(Color.black)
                                            .frame(width: 20, height: 50)
                                        }
                                        Spacer()
                                        ForEach(Array(self.gameDataStore.gamesByYear[self.getCurrentYear() + 1]![month]![day]!), id: \.self) { gameId in
                                            HStack {
                                                FollowGameIcon(game: self.gameDataStore.games[gameId]!)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
