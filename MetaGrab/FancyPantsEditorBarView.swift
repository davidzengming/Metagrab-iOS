//
//  FancyPantsEditorBarView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-01-06.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct FancyPantsEditorView: View {
    @Binding var newTextStorage: NSTextStorage
    @Binding var isEditable: Bool
    
    @State var isBold: Bool = false
    @State var isItalic: Bool = false
    @State var isStrikethrough: Bool = false
    @State var isDashBulletList: Bool = false
    @State var isNumberedBulletList: Bool = false
    
    @State var didChangeBold: Bool = false
    @State var didChangeItalic: Bool = false
    @State var didChangeStrikethrough: Bool = false
    @State var didChangeBulletList: Bool = false
    @State var didChangeNumberedBulletList: Bool = false
    
    var isNewContent: Bool
    var isThread: Bool
    var threadId: Int?
    var commentId: Int?
    var isFirstResponder: Bool
    
    func toggleBold() {
        isBold = !isBold
    }
    
    func turnOnDidChangeBold() {
        didChangeBold = true
    }
    
    func toggleItalic() {
        isItalic = !isItalic
    }
    
    func turnOnDidChangeItalic() {
        didChangeItalic = true
    }
    
    func toggleStrikethrough() {
        isStrikethrough = !isStrikethrough
    }
    
    func turnOnDidChangeStrikethrough() {
        didChangeStrikethrough = true
    }
    
    func toggleBulletList() {
        isDashBulletList = !isDashBulletList
    }
    
    func turnOnDidChangeBulletList() {
        didChangeBulletList = true
    }
    
    func toggleNumberBulletList() {
        isNumberedBulletList = !isNumberedBulletList
    }
    
    func turnOnDidChangeNumberedBulletList() {
        didChangeNumberedBulletList = true
    }
    
    var body: some View {
        GeometryReader { a in
            VStack(spacing: 0) {
                if self.isEditable {
                    GeometryReader { b in
                            HStack(spacing: 0) {
                                Button(action: {
                                    self.turnOnDidChangeBold()
                                    self.toggleBold()
                                }) {
                                    Image(systemName: "bold")
                                        .resizable()
                                        .padding(10)
                                        .foregroundColor(self.isBold ? .black : .gray)
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
                                        .foregroundColor(self.isItalic ? .black : .gray)
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
                                        .foregroundColor(self.isStrikethrough ? .black : .gray)
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
                                        .foregroundColor(self.isDashBulletList ? .black : .gray)
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
                                        .foregroundColor(self.isNumberedBulletList ? .black : .gray)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: min(b.size.width, b.size.height), height: min(b.size.width, b.size.height), alignment: .center)
                                
                                Spacer()
                            }.frame(alignment: .leading)
                        }
                        .frame(width: a.size.width, height: a.size.height * 0.1, alignment: .leading)
                        .background(Color.yellow)
                    }
                
                TextView(
                    newTextStorage: self.$newTextStorage,
                    isBold: self.$isBold,
                    isItalic: self.$isItalic,
                    isStrikethrough: self.$isStrikethrough,
                    isDashBulletList: self.$isDashBulletList,
                    isNumberedBulletList: self.$isNumberedBulletList,
                    didChangeBold: self.$didChangeBold,
                    didChangeItalic: self.$didChangeItalic,
                    didChangeStrikethrough: self.$didChangeStrikethrough,
                    didChangeBulletList: self.$didChangeBulletList,
                    didChangeNumberedBulletList: self.$didChangeNumberedBulletList,
                    isEditable: self.$isEditable,
                    isNewContent: self.isNewContent,
                    isThread: self.isThread,
                    threadId:self.threadId,
                    commentId: self.commentId,
                    isFirstResponder: self.isFirstResponder
                )
            }
            
        }
    }
}
