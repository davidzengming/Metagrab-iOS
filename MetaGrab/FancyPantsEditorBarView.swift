//
//  FancyPantsEditorBarView.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-01-06.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import SwiftUI

struct FancyPantsEditorBarView: View {
    @Binding var isBold: Bool
    @Binding var isNumberedBulletList: Bool
    @Binding var didChangeBold: Bool
    @Binding var didChangeNumberedBulletList: Bool
    
    func toggleBold() {
        isBold = !isBold
    }
    
    func turnOnDidChangeBold() {
        didChangeBold = true
    }
    
    func toggleNumberBulletList() {
        isNumberedBulletList = !isNumberedBulletList
    }
    
    func turnOnDidChangeNumberedBulletList() {
        didChangeNumberedBulletList = true
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.turnOnDidChangeBold()
                self.toggleBold()
            }) {
                if isBold {
                    Text("B")
                    .bold()
                } else {
                    Text("B")
                }
            }.background(Color.white)
            
            Button(action: {
                self.turnOnDidChangeNumberedBulletList()
                self.toggleNumberBulletList()
            }) {
                if isNumberedBulletList {
                    Text("123=")
                    .bold()
                } else {
                    Text("123=")
                }
            }
        }
    }
}
