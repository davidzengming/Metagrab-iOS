//
//  FancyPantsBarView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-03-17.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct FancyPantsBarView: View {
    @ObservedObject var fancyPantsBarStateObject: FancyPantsBarStateObject
    
    func toggleBold() {
        self.fancyPantsBarStateObject.isBold = !self.fancyPantsBarStateObject.isBold
    }
    
    func turnOnDidChangeBold() {
        self.fancyPantsBarStateObject.didChangeBold = true
    }
    
    func toggleItalic() {
        self.fancyPantsBarStateObject.isItalic = !self.fancyPantsBarStateObject.isItalic
    }
    
    func turnOnDidChangeItalic() {
        self.fancyPantsBarStateObject.didChangeItalic = true
    }
    
    func toggleStrikethrough() {
        self.fancyPantsBarStateObject.isStrikethrough = !self.fancyPantsBarStateObject.isStrikethrough
    }
    
    func turnOnDidChangeStrikethrough() {
        self.fancyPantsBarStateObject.didChangeStrikethrough = true
    }
    
    func toggleBulletList() {
        self.fancyPantsBarStateObject.isDashBulletList = !self.fancyPantsBarStateObject.isDashBulletList
    }
    
    func turnOnDidChangeBulletList() {
        self.fancyPantsBarStateObject.didChangeBulletList = true
    }
    
    func toggleNumberBulletList() {
        self.fancyPantsBarStateObject.isNumberedBulletList = !self.fancyPantsBarStateObject.isNumberedBulletList
    }
    
    func turnOnDidChangeNumberedBulletList() {
        self.fancyPantsBarStateObject.didChangeNumberedBulletList = true
    }
    
    var body: some View {
        GeometryReader { a in
            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { b in
                    HStack(spacing: 0) {
                        Button(action: {
                            self.turnOnDidChangeBold()
                            self.toggleBold()
                        }) {
                            Image(systemName: "bold")
                                .resizable()
                                .padding(10)
                                .foregroundColor(self.fancyPantsBarStateObject.isBold ? .black : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: min(b.size.width, b.size.height), height: min(b.size.width, b.size.height), alignment: .center)
                        
                        Button(action: {
                            self.turnOnDidChangeItalic()
                            self.toggleItalic()
                        }) {
                            Image(systemName: "italic")
                                .resizable()
                                .padding(10)
                                .foregroundColor(self.fancyPantsBarStateObject.isItalic ? .black : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: min(b.size.width, b.size.height), height: min(b.size.width, b.size.height), alignment: .center)
                        
                        Button(action: {
                            self.turnOnDidChangeStrikethrough()
                            self.toggleStrikethrough()
                        }) {
                            Image(systemName: "strikethrough")
                                .resizable()
                                .padding(10)
                                .foregroundColor(self.fancyPantsBarStateObject.isStrikethrough ? .black : .gray)
                        }
                            
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: min(b.size.width, b.size.height), height: min(b.size.width, b.size.height), alignment: .center)
                        
                        Button(action: {
                            self.turnOnDidChangeBulletList()
                            self.toggleBulletList()
                        }) {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .padding(10)
                                .foregroundColor(self.fancyPantsBarStateObject.isDashBulletList ? .black : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: min(b.size.width, b.size.height), height: min(b.size.width, b.size.height), alignment: .center)
                        
                        Button(action: {
                            self.turnOnDidChangeNumberedBulletList()
                            self.toggleNumberBulletList()
                        }) {
                            Image(systemName: "list.number")
                                .resizable()
                                .padding(10)
                                .foregroundColor(self.fancyPantsBarStateObject.isNumberedBulletList ? .black : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: min(b.size.width, b.size.height), height: min(b.size.width, b.size.height), alignment: .center)
                        
                        Spacer()
                    }.frame(alignment: .leading)
                }
                .frame(width: a.size.width, height: a.size.height * 0.3, alignment: .leading)
                .background(Color.yellow)
            }
        }
    }
}
