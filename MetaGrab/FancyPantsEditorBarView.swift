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
    
    var isNewContent: Bool
    var isThread: Bool
    var threadId: Int?
    var commentId: Int?
    var isFirstResponder: Bool
    @ObservedObject var fancyPantsBarStateObject: FancyPantsBarStateObject
    
    var body: some View {
        VStack(spacing: 0) {
            TextView(
                newTextStorage: self.$newTextStorage,
                isBold: self.$fancyPantsBarStateObject.isBold,
                isItalic: self.$fancyPantsBarStateObject.isItalic,
                isStrikethrough: self.$fancyPantsBarStateObject.isStrikethrough,
                isDashBulletList: self.$fancyPantsBarStateObject.isDashBulletList,
                isNumberedBulletList: self.$fancyPantsBarStateObject.isNumberedBulletList,
                didChangeBold: self.$fancyPantsBarStateObject.didChangeBold,
                didChangeItalic: self.$fancyPantsBarStateObject.didChangeItalic,
                didChangeStrikethrough: self.$fancyPantsBarStateObject.didChangeStrikethrough,
                didChangeBulletList: self.$fancyPantsBarStateObject.didChangeBulletList,
                didChangeNumberedBulletList: self.$fancyPantsBarStateObject.didChangeNumberedBulletList,
                isEditable: self.$isEditable,
                isNewContent: self.isNewContent,
                isThread: self.isThread,
                threadId:self.threadId,
                commentId: self.commentId,
                isFirstResponder: self.isFirstResponder
            )
                .padding(.all, self.isEditable || self.isNewContent ? 10 : 0)
        }
    }
}
