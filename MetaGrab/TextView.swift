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
    @Binding var text: NSMutableString
    @Binding var isBold: Bool
    @Binding var isNumberedBulletList: Bool
    @Binding var didChangeBold: Bool
    @Binding var didChangeNumberedBulletList: Bool
    var textStorage: NSTextStorage
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, textStorage: textStorage)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
        let attrString = NSAttributedString(string: self.text as String, attributes: attrs)
        textStorage.setAttributedString(attrString)
        
        let layoutManager = NSLayoutManager()
        
        let containerSize = CGSize(width: 300, height: 200)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        textStorage.addLayoutManager(layoutManager)
        
        let myTextView = UITextView(frame: CGRect(x: 0, y:0, width: 1024, height: 768), textContainer: container)
        
        myTextView.delegate = context.coordinator
        myTextView.font = UIFont(name: "HelveticaNeue", size: 15)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        return myTextView
    }
    
    
    func formatNumberedBulletList(selectedStr: NSAttributedString) -> NSAttributedString {
        let res = NSMutableAttributedString(string: "1. ")
        
        
        return NSAttributedString(string: "Wut\nKappa")
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if didChangeBold == true {
            if isBold == true {
                let newFont = UIFont.systemFont(ofSize: 15, weight: .bold)
                textStorage.addAttributes([.font: newFont], range: uiView.selectedRange)
            } else {
                let defaultFont = UIFont.systemFont(ofSize: 15, weight: .regular)
                textStorage.addAttributes([.font: defaultFont], range: uiView.selectedRange)
            }
            setDidChangeBold(to: false)
        }
        
        if didChangeNumberedBulletList == true {
            let selectedStr = textStorage.attributedSubstring(from: uiView.selectedRange)
            textStorage.replaceCharacters(in: uiView.selectedRange, with: formatNumberedBulletList(selectedStr: selectedStr))
            setDidChangeNumberedBulletList(to: false)
        }
    }
    
    func setDidChangeBold(to status: Bool) {
        DispatchQueue.main.async {
            self.didChangeBold = status
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
        
        init(_ textView: TextView, textStorage: NSTextStorage) {
            self.parent = textView
            self.textStorage = textStorage
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if self.parent.isBold == true {
                let newFont = UIFont.systemFont(ofSize: 15, weight: .bold)
                textView.typingAttributes = [.font: newFont]
            } else {
                let defaultFont = UIFont.systemFont(ofSize: 15, weight: .regular)
                textView.typingAttributes = [.font: defaultFont]
            }
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
            DispatchQueue.main.async {
                self.parent.text = textView.textStorage.mutableString
                print("shouldbe called second")
            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            print(textView.selectedRange, "changed by caret to select -- ")
            
            let i = textView.selectedRange.location
            let k = textView.selectedRange.length
            
            if k > 0 {
                var isAllBolded = true
                
                let s = textStorage.attributedSubstring(from: NSRange(i..<i + k))
                s.enumerateAttribute(NSAttributedString.Key.font, in: NSRange(0..<s.length), options: .longestEffectiveRangeNotRequired) {
                    value, range, stop in
                    let font = value as! UIFont
                    if !font.fontName.contains("Bold") {
                        isAllBolded = false
                        stop.pointee = true // return early
                    }
                }
                
                if isAllBolded == true {
                    setBoldState(to: true)
                } else {
                    setBoldState(to: false)
                }
                
                setDidChangeBold(to: false)
            }
        }
        
        func setDidChangeBold(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.didChangeBold = status
            }
            
        }
        
        func setBoldState(to status: Bool) {
            DispatchQueue.main.async {
                self.parent.isBold = status
            }
        }
    }
}
