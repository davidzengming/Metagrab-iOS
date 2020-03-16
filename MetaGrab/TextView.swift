//
//  TextView.swift
//  MetaGrab
//
//  Created by David Zeng on 2019-11-28.
//  Copyright © 2019 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    
    @EnvironmentObject var gameDataStore: GameDataStore
    @Binding var newTextStorage: NSTextStorage
    
    @Binding var isBold: Bool
    @Binding var isItalic: Bool
    @Binding var isStrikethrough: Bool
    @Binding var isDashBulletList: Bool
    @Binding var isNumberedBulletList: Bool
    
    @Binding var didChangeBold: Bool
    @Binding var didChangeItalic: Bool
    @Binding var didChangeStrikethrough: Bool
    @Binding var didChangeBulletList: Bool
    @Binding var didChangeNumberedBulletList: Bool
    
    @Binding var isEditable: Bool
    
    var isNewContent: Bool
    var isThread: Bool
    var threadId: Int?
    var commentId: Int?
    var isFirstResponder: Bool = false
    
    func makeCoordinator() -> Coordinator {
        if isNewContent {
            return Coordinator(self, textStorage: newTextStorage)
        }
        
        if isThread {
            return Coordinator(self, textStorage: gameDataStore.threadsTextStorage[threadId!]!)
        } else {
            return Coordinator(self, textStorage: gameDataStore.commentsTextStorage[commentId!]!)
        }
    }
    
    func makeUIView(context: Context) -> UITextView {
        let layoutManager = NSLayoutManager()
        let containerSize = CGSize(width: 300, height: 200)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        
        if isNewContent {
            newTextStorage.addLayoutManager(layoutManager)
        } else {
            if isThread {
                gameDataStore.threadsTextStorage[threadId!]!.addLayoutManager(layoutManager)
            } else {
                gameDataStore.commentsTextStorage[commentId!]!.addLayoutManager(layoutManager)
            }
        }
        
        let myTextView = UITextView(frame: CGRect(x: 0, y:0, width: 1024, height: 768), textContainer: container)
        myTextView.delegate = context.coordinator
        if isNewContent {
            myTextView.font = TextViewHelper.getHelveticaNeueFont(isBold: isBold)
        }
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = isEditable ? true : false
        myTextView.backgroundColor = UIColor.clear
        myTextView.textContainerInset = UIEdgeInsets.zero
        myTextView.textContainer.lineFragmentPadding = 0
        
        DispatchQueue.main.async {
            if self.isNewContent == false {
                if self.isThread == true {
                    self.gameDataStore.threadsDesiredHeight[self.threadId!] = TextViewHelper.calculateTextViewHeight(textView: myTextView)
                } else {
                    self.gameDataStore.commentsDesiredHeight[self.commentId!] = TextViewHelper.calculateTextViewHeight(textView: myTextView)
                }
            }
        }
    
        return myTextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
        
        let leftCaretPos = uiView.selectedRange.location
        let rightCaretPos = uiView.selectedRange.location + uiView.selectedRange.length
        
        if uiView.isUserInteractionEnabled != isEditable {
            uiView.isUserInteractionEnabled = isEditable
        }
        
        if didChangeBold == true {
            if isBold == true {
                uiView.textStorage.addAttributes([.font: TextViewHelper.getHelveticaNeueFont(isBold: true, isItalic: isItalic)], range: uiView.selectedRange)
            } else {
                uiView.textStorage.addAttributes([.font: TextViewHelper.getHelveticaNeueFont(isBold: false, isItalic: isItalic)], range: uiView.selectedRange)
            }
            
            setDidChangeBold(to: false)
        }
        
        if didChangeItalic == true {
            if isItalic == true {
                uiView.textStorage.addAttributes([.font: TextViewHelper.getHelveticaNeueFont(isBold: isBold, isItalic: true)], range: uiView.selectedRange)
            } else {
                uiView.textStorage.addAttributes([.font: TextViewHelper.getHelveticaNeueFont(isBold: isBold, isItalic: false)], range: uiView.selectedRange)
            }
            
            setDidChangeItalic(to: false)
        }
        
        if didChangeStrikethrough == true {
            
            if isStrikethrough == true {
                uiView.textStorage.addAttributes([.strikethroughStyle: NSUnderlineStyle.single.rawValue], range: uiView.selectedRange)
            } else {
                uiView.textStorage.removeAttribute(.strikethroughStyle, range: uiView.selectedRange)
            }
            
            setDidChangeStrikethrough(to: false)
        }
        
        if didChangeNumberedBulletList == true {
            if leftCaretPos == rightCaretPos {
                TextViewHelper.findLineAndReplaceWithBulletLine(isNumbered: true, leftCaretPos: leftCaretPos, textStorage: uiView.textStorage, uiView: uiView)
                setDidChangeNumberedBulletList(to: false)
            } else {
                let selectedStr = uiView.textStorage.attributedSubstring(from: uiView.selectedRange)
                uiView.textStorage.replaceCharacters(in: uiView.selectedRange, with: TextViewHelper.getFormattedBulletListAttributedString(isNumbered: true, selectedStr: selectedStr))
                setDidChangeNumberedBulletList(to: false)
            }
        }
        
        if didChangeBulletList == true {
            if leftCaretPos == rightCaretPos {
                TextViewHelper.findLineAndReplaceWithBulletLine(isNumbered: false, leftCaretPos: leftCaretPos, textStorage: uiView.textStorage, uiView: uiView)
                setDidChangeNumberedBulletList(to: false)
            } else {
                let selectedStr = uiView.textStorage.attributedSubstring(from: uiView.selectedRange)
                uiView.textStorage.replaceCharacters(in: uiView.selectedRange, with: TextViewHelper.getFormattedBulletListAttributedString(isNumbered: false, selectedStr: selectedStr))
                setDidChangeNumberedBulletList(to: false)
            }
        }
    }
    
    func setDidChangeBold(to status: Bool) {
        DispatchQueue.main.async {
            self.didChangeBold = status
        }
    }
    
    func setDidChangeItalic(to status: Bool) {
        DispatchQueue.main.async {
            self.didChangeItalic = status
        }
    }
    
    func setDidChangeStrikethrough(to status: Bool) {
        DispatchQueue.main.async {
            self.didChangeStrikethrough = status
        }
    }
    
    func setDidChangeNumberedBulletList(to status: Bool) {
        DispatchQueue.main.async {
            self.didChangeNumberedBulletList = status
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        var textStorage: NSTextStorage
        var didBecomeFirstResponder = false
        
        init(_ textView: TextView, textStorage: NSTextStorage) {
            self.parent = textView
            self.textStorage = textStorage
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let leftCaretPos = textView.selectedRange.location
            let k = textView.selectedRange.length
            //let rightCaretPos = leftCaretPos + k - 1
            
            TextViewHelper.prepareTypingAttributesSetting(textView: textView, isBold: self.parent.isBold, isItalic: self.parent.isItalic, isStrikethrough: self.parent.isStrikethrough, isBulletList: self.parent.isDashBulletList, isNumberedList: self.parent.isNumberedBulletList)
            
            if self.parent.isNumberedBulletList == true {
                let enumerateKey = NSAttributedString.Key.numberedListAttribute
                let enumerateHeaderKey = NSAttributedString.Key.numberHeaderInBulletList
                
                if text == "\n" { // new line
                    TextViewHelper.formatNewLineAndAdjustCursor(isNumbered: true, leftCaretPos: leftCaretPos, enumerateKey: enumerateKey, enumerateHeaderKey: enumerateHeaderKey, textStorage: self.textStorage, textView: textView)
                    return false
                } else if text == "" && range.length == 1 && k == 0 {
                    let isRightSideCaret = TextViewHelper.isRightSideCaret(at: leftCaretPos, textStorage: self.textStorage)
                    let lineStartIndex = TextViewHelper.getListLineStart(index: leftCaretPos, isRightSideCaret: isRightSideCaret, textStorage: textStorage, enumerateHeaderKey: enumerateHeaderKey)
                    let lineNumberRangeTuple : (start: Int, end: Int) = TextViewHelper.getLineHeaderRange(enumerateHeaderKey: enumerateHeaderKey, index: lineStartIndex, textStorage: textStorage)
                    
                    if leftCaretPos == lineNumberRangeTuple.end + TextViewHelper.getBulletListIndentStr().count + 1 {
                        TextViewHelper.deleteLineBackspace(isNumbered: true, leftCaretPos: leftCaretPos, enumerateKey: enumerateKey, enumerateHeaderKey: enumerateHeaderKey, textStorage: self.textStorage, textView: textView, isRightSideCaret: isRightSideCaret, lineNumberRangeTuple: lineNumberRangeTuple)
                        
                        return false
                    }
                }
            }
            
            if self.parent.isDashBulletList == true {
                let enumerateKey = NSAttributedString.Key.dashListAttribute
                let enumerateHeaderKey = NSAttributedString.Key.dashHeaderInBulletList
                
                if text == "\n" {
                    TextViewHelper.formatNewLineAndAdjustCursor(isNumbered: false, leftCaretPos: leftCaretPos, enumerateKey: enumerateKey, enumerateHeaderKey: enumerateHeaderKey, textStorage: self.textStorage, textView: textView)
                    return false
                } else if text == "" && range.length == 1 && k == 0 {
                    let isRightSideCaret = TextViewHelper.isRightSideCaret(at: leftCaretPos, textStorage: self.textStorage)
                    let lineStartIndex = TextViewHelper.getListLineStart(index: leftCaretPos, isRightSideCaret: isRightSideCaret, textStorage: textStorage, enumerateHeaderKey: enumerateHeaderKey)
                    let lineNumberRangeTuple : (start: Int, end: Int) = TextViewHelper.getLineHeaderRange(enumerateHeaderKey: enumerateHeaderKey, index: lineStartIndex, textStorage: textStorage)
                    
                    if leftCaretPos == lineNumberRangeTuple.end + TextViewHelper.getDashBulletListIndentStr().count + 1 {
                        TextViewHelper.deleteLineBackspace(isNumbered: false, leftCaretPos: leftCaretPos, enumerateKey: enumerateKey , enumerateHeaderKey: enumerateHeaderKey, textStorage: self.textStorage, textView: textView, isRightSideCaret: isRightSideCaret, lineNumberRangeTuple: lineNumberRangeTuple)
                        return false
                    }
                }
            }
            
            return true
        }
        
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                if self.parent.isNewContent == false {
                    if self.parent.isThread == true {
                        self.parent.gameDataStore.threadsDesiredHeight[self.parent.threadId!] = TextViewHelper.calculateTextViewHeight(textView: textView)
                    } else {
                        self.parent.gameDataStore.commentsDesiredHeight[self.parent.commentId!] = TextViewHelper.calculateTextViewHeight(textView: textView)
                    }
                }
            }
            
            //            not needed - textStorage state already receives update via binding
            //            DispatchQueue.main.async {
            //                self.parent.textStorage = textView.textStorage
            //            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            if parent.isEditable == false {
                return
            }
            
            let leftCaretPos = textView.selectedRange.location
            let k = textView.selectedRange.length
            let rightCaretPos = leftCaretPos + k
            
            let isRightSideCaret = TextViewHelper.isRightSideCaret(at: leftCaretPos, textStorage: self.textStorage)
            var nextBoldState = false
            var nextItalicState = false
            var nextStrikethroughState = false
            
            var nextNumberedListState = false
            var nextDashListState = false
            
            if k > 0 {
                nextBoldState = TextViewHelper.isAllBoldInSubstring(s: textStorage.attributedSubstring(from: NSMakeRange(leftCaretPos, k))) ? true : false
                nextItalicState = TextViewHelper.isAllItalicInSubstring(s: textStorage.attributedSubstring(from: NSMakeRange(leftCaretPos, k))) ? true : false
                nextStrikethroughState = TextViewHelper.isAllContainAttributeInSubstring(enumerateKey: NSAttributedString.Key.strikethroughStyle, s: textStorage.attributedSubstring(from: NSMakeRange(leftCaretPos, k))) ? true : false
                
                nextNumberedListState = TextViewHelper.isAllContainAttributeInSubstring(enumerateKey: NSAttributedString.Key.numberedListAttribute, s: textStorage.attributedSubstring(from: NSMakeRange(leftCaretPos, k))) ? true : false
                nextDashListState = TextViewHelper.isAllContainAttributeInSubstring(enumerateKey: NSAttributedString.Key.dashListAttribute, s: textStorage.attributedSubstring(from: NSMakeRange(leftCaretPos, k))) ? true : false
                
                let isLeftSelectInNumberedList = TextViewHelper.isLastCharAttribute(attribute: NSAttributedString.Key.numberedListAttribute, index: leftCaretPos, isRightSideCaret: false, textStorage: textStorage) ? true : false
                let isRightSelectInNumberedList = TextViewHelper.isLastCharAttribute(attribute: NSAttributedString.Key.numberedListAttribute, index: rightCaretPos, isRightSideCaret: true, textStorage: textStorage) ? true : false
                
                if isLeftSelectInNumberedList == true {
                    TextViewHelper.adjustLeftCursorFromForbiddenSpace(leftCaretPos: leftCaretPos, textStorage: textStorage, k: k, textView: textView, isNumberedList: true)
                }
                
                if isRightSelectInNumberedList == true {
                    TextViewHelper.adjustRightCursorFromForbiddenSpace(rightCaretPos: rightCaretPos, textStorage: textStorage, k: k, textView: textView, isNumberedList: true)
                }
                
                let isLeftSelectInDashList = TextViewHelper.isLastCharAttribute(attribute: NSAttributedString.Key.dashListAttribute, index: leftCaretPos, isRightSideCaret: false, textStorage: textStorage) ? true : false
                let isRightSelectInDashList = TextViewHelper.isLastCharAttribute(attribute: NSAttributedString.Key.dashListAttribute, index: rightCaretPos, isRightSideCaret: true, textStorage: textStorage) ? true : false
                
                if isLeftSelectInDashList == true {
                    TextViewHelper.adjustLeftCursorFromForbiddenSpace(leftCaretPos: leftCaretPos, textStorage: textStorage, k: k, textView: textView, isNumberedList: false)
                }
                
                if isRightSelectInDashList == true {
                    TextViewHelper.adjustRightCursorFromForbiddenSpace(rightCaretPos: rightCaretPos, textStorage: textStorage, k: k, textView: textView, isNumberedList: false)
                }
                
            } else {
                nextBoldState = TextViewHelper.isLastCharBold(index: leftCaretPos, isRightSideCaret: isRightSideCaret, textStorage: textStorage) ? true : false
                nextItalicState = TextViewHelper.isLastCharItalic(index: leftCaretPos, isRightSideCaret: isRightSideCaret, textStorage: textStorage) ? true : false
                nextStrikethroughState = TextViewHelper.isLastCharAttribute(attribute: NSAttributedString.Key.strikethroughStyle , index: leftCaretPos, isRightSideCaret: isRightSideCaret, textStorage: textStorage) ? true : false
                
                nextNumberedListState = TextViewHelper.isLastCharAttribute(attribute: NSAttributedString.Key.numberedListAttribute, index: leftCaretPos, isRightSideCaret: isRightSideCaret, textStorage: textStorage) ? true : false
                nextDashListState = TextViewHelper.isLastCharAttribute(attribute: NSAttributedString.Key.dashListAttribute, index: leftCaretPos, isRightSideCaret: isRightSideCaret, textStorage: textStorage) ? true : false
                
                if nextNumberedListState == true || nextDashListState == true {
                    TextViewHelper.adjustLeftCursorFromForbiddenSpace(leftCaretPos: leftCaretPos, textStorage: textStorage, k: k, textView: textView, isNumberedList: nextNumberedListState ? true : false)
                }
            }
            
            setBoldState(to: nextBoldState)
            setDidChangeBold(to: false)
            
            setItalicState(to: nextItalicState)
            setDidChangeItalic(to: false)
            
            setStrikethroughState(to: nextStrikethroughState)
            setDidChangeStrikethrough(to: false)
            
            setNumberedBulletListState(to: nextNumberedListState)
            setDidChangeNumberedBulletList(to: false)
            
            setDashBulletListState(to: nextDashListState)
            setDidChangeDashBulletList(to: false)
            
            DispatchQueue.main.async {
                TextViewHelper.prepareTypingAttributesSetting(textView: textView, isBold: self.parent.isBold, isItalic: self.parent.isItalic, isStrikethrough: self.parent.isStrikethrough, isBulletList: self.parent.isDashBulletList, isNumberedList: self.parent.isNumberedBulletList)
            }
        }
        
        func setDidChangeBold(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.didChangeBold = status
            }
            
        }
        
        func setDidChangeItalic(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.didChangeBold = status
            }
            
        }
        
        func setDidChangeStrikethrough(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.didChangeStrikethrough = status
            }
        }
        
        
        func setDidChangeNumberedBulletList(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.didChangeNumberedBulletList = status
            }
        }
        
        func setDidChangeDashBulletList(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.didChangeBulletList = status
            }
        }
        
        func setBoldState(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.isBold = status
            }
        }
        
        func setItalicState(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.isItalic = status
            }
        }
        
        func setStrikethroughState(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.isStrikethrough = status
            }
        }
        
        func setNumberedBulletListState(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.isNumberedBulletList = status
            }
        }
        
        func setDashBulletListState(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.isDashBulletList = status
            }
        }
    }
}
