//
//  FancyPantsBarStateStore.swift
//  MetaGrab
//
//  Created by David Zeng on 2020-03-17.
//  Copyright © 2020 David Zeng. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class FancyPantsBarStateObject: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    var isBold: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isItalic: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isStrikethrough: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isDashBulletList: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var isNumberedBulletList: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var didChangeBold: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var didChangeItalic: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var didChangeStrikethrough: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var didChangeBulletList: Bool = false{
        willSet {
            objectWillChange.send()
        }
    }
    
    var didChangeNumberedBulletList: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
}
